import Foundation
import AVFoundation
import Combine

class AudioPlayerService {
    private var engine = AVAudioEngine()
    private var playerA = AVAudioPlayerNode()
    private var playerB = AVAudioPlayerNode()
    private var audioFile: AVAudioFile?
    
    private var playbackTimer: Timer?
    private var isPlayerA = true
    
    private var audioFileDuration: TimeInterval = 120.0 // Default value
    private let fadeDuration: TimeInterval = 4.0
    
    private var fadeTask: Task<Void, Never>?
    private var wasPlayingBeforeInterruption = false

    init() {
        setupAudioSession()
        setupEngine()
        setupInterruptionObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    private func setupEngine() {
        engine.attach(playerA)
        engine.attach(playerB)
        
        engine.connect(playerA, to: engine.mainMixerNode, format: nil)
        engine.connect(playerB, to: engine.mainMixerNode, format: nil)
        
        engine.prepare()
    }
    
    private func setupInterruptionObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleInterruption),
                                               name: AVAudioSession.interruptionNotification,
                                               object: nil)
    }

    func play(fileName: String) {
        fadeTask?.cancel()
        stopPlayback()

        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "mp3"),
              let audioFile = try? AVAudioFile(forReading: fileURL) else {
            print("Error: Could not load audio file \(fileName).mp3.")
            return
        }
        self.audioFile = audioFile
        
        // Dynamically calculate the duration from the audio file
        let fileDuration = Double(audioFile.length) / audioFile.processingFormat.sampleRate
        if fileDuration > 0 {
            self.audioFileDuration = fileDuration
        }

        if !engine.isRunning {
            do {
                try engine.start()
            } catch {
                print("Failed to start audio engine: \(error)")
                return
            }
        }

        playerA.volume = 0
        playerB.volume = 0
        isPlayerA = true
        scheduleAndPlay(player: playerA)
        startPlaybackTimer()
        
        fadeTask = Task {
            await rampVolume(to: 1.0, duration: 2.0)
        }
    }

    func stop() {
        fadeTask?.cancel()
        
        fadeTask = Task {
            await rampVolume(to: 0.0, duration: 2.0)
            if !Task.isCancelled {
                self.stopPlayback()
                if self.engine.isRunning {
                    self.engine.stop()
                }
            }
        }
    }
    
    private func stopPlayback() {
        playbackTimer?.invalidate()
        playbackTimer = nil
        if playerA.isPlaying {
            playerA.stop()
        }
        if playerB.isPlaying {
            playerB.stop()
        }
    }

    private func scheduleAndPlay(player: AVAudioPlayerNode) {
        guard let audioFile = audioFile else { return }
        player.scheduleFile(audioFile, at: nil, completionHandler: nil)
        player.play()
    }

    private func startPlaybackTimer() {
        playbackTimer?.invalidate()
        let timeInterval = audioFileDuration - fadeDuration
        
        playbackTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            if self.isPlayerA {
                self.scheduleAndPlay(player: self.playerB)
            } else {
                self.scheduleAndPlay(player: self.playerA)
            }
            
            self.isPlayerA.toggle()
            self.startPlaybackTimer()
        }
    }
    
    private func rampVolume(to targetVolume: Float, duration: TimeInterval) async {
        let steps = 100
        let stepDuration = duration / Double(steps)
        let initialVolume = playerA.volume // Both players should have the same volume

        for i in 0...steps {
            if Task.isCancelled { return }
            let progress = Float(i) / Float(steps)
            let newVolume = initialVolume + (targetVolume - initialVolume) * progress
            playerA.volume = newVolume
            playerB.volume = newVolume
            try? await Task.sleep(nanoseconds: UInt64(stepDuration * 1_000_000_000))
        }
    }
    
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }

        switch type {
        case .began:
            // Interruption began, pause audio
            wasPlayingBeforeInterruption = engine.isRunning
            if wasPlayingBeforeInterruption {
                engine.pause()
            }
        case .ended:
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) && wasPlayingBeforeInterruption {
                // Interruption ended, and we should resume playback.
                do {
                    try engine.start()
                    wasPlayingBeforeInterruption = false
                } catch {
                    print("Failed to restart engine after interruption: \(error)")
                }
            }
        @unknown default:
            break
        }
    }
}
