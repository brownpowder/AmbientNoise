
import SwiftUI

struct PlayerView: View {
    @ObservedObject var viewModel: SoundViewModel
    let sound: Sound
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            // Base dark brown background to match the theme
            Color(red: 0.15, green: 0.1, blue: 0.08)
                .edgesIgnoringSafeArea(.all)

            // Blurred background image with adjusted opacity
            Image(sound.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 10)
                .opacity(0.4)

            // Vignette effect using a radial gradient
            RadialGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.6)]),
                center: .center,
                startRadius: 100,
                endRadius: 450
            )
            .edgesIgnoringSafeArea(.all)
            
            // Custom Back Button
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(12)
                            .background(Color.black.opacity(0.3).clipShape(Circle()))
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
                Spacer()
            }
            .padding()
            .padding(.top, 20) // Move down from the status bar
            
            // Visualizer
            Circle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 150, height: 150)
                .scaleEffect(1.0 + CGFloat(viewModel.audioLevel) * 1.5)
                .animation(.easeInOut(duration: 0.15), value: viewModel.audioLevel)

            // UI Controls
            VStack(spacing: 20) {
                Spacer()
                
                VStack(alignment: .leading, spacing: 15) {
                    Text(sound.name)
                        .font(.custom("Futura-Bold", size: 35))
                        .foregroundColor(.white.opacity(0.9))
                        .tracking(8)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)

                    Text(sound.description)
                        .font(.custom("Futura-Medium", size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.leading)
                        .lineSpacing(5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        viewModel.togglePlayback()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 20, weight: .bold))

                            Text(viewModel.isPlaying ? "Pause" : "Play")
                                .font(.custom("Futura-Bold", size: 20))
                                .tracking(6)
                        }
                        .padding(.horizontal, 35)
                        .padding(.vertical, 18)
                        .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.9))
                                .shadow(radius: 15)
                        )
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                } 
                
                Spacer()
                Spacer()
            }
            .padding()
        }
        .onAppear {
            viewModel.selectedSound = sound
        }
        .onDisappear {
            viewModel.stop()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SoundViewModel()
        let sound = viewModel.sounds[0]
        PlayerView(viewModel: viewModel, sound: sound)
    }
}
