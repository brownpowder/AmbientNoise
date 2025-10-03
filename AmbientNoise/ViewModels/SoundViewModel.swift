
import Foundation
import Combine

class SoundViewModel: ObservableObject {
    @Published var sounds: [Sound] = [
        Sound(name: "White Noise", fileName: "white-noise", imageName: "white-noise-bg", description: "Contains all frequencies at equal intensity. Said to improve focus and help mask tinnitus.", isPremium: false),
        Sound(name: "Red Noise", fileName: "red-noise", imageName: "red-noise-bg", description: "Also known as Brown Noise, this is a deeper sound with emphasized lower frequencies. Ideal for relaxation.", isPremium: false),
        Sound(name: "Pink Noise", fileName: "pink-noise", imageName: "pink-noise-bg", description: "A balanced, natural sound with reduced high frequencies, often compared to steady rainfall. Great for sleep.", isPremium: false)
    ]
    
    @Published var selectedSound: Sound? {
        didSet {
            // Stop previous sound if a new one is selected
            if oldValue != selectedSound {
                stop()
            }
        }
    }
    @Published var isPlaying = false
    
    private let audioPlayerService = AudioPlayerService()
    
    func togglePlayback() {
        guard let sound = selectedSound else { return }
        
        isPlaying.toggle()
        
        if isPlaying {
            audioPlayerService.play(fileName: sound.fileName)
        } else {
            audioPlayerService.stop()
        }
    }
    
    func stop() {
        if isPlaying {
            audioPlayerService.stop()
            isPlaying = false
        }
    }
}
