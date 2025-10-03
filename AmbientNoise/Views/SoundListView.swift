
import SwiftUI

struct SoundListView: View {
    @StateObject private var viewModel = SoundViewModel()

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                // Base dark brown background to match the theme
                Color(red: 0.15, green: 0.1, blue: 0.08)
                    .edgesIgnoringSafeArea(.all)

                // Blurred background image from white noise
                Image("white-noise-bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 10)
                    .opacity(0.4)
                
                // Vignette effect to match PlayerView
                RadialGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.6)]),
                    center: .center,
                    startRadius: 100,
                    endRadius: 450
                )
                .edgesIgnoringSafeArea(.all)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.sounds) { sound in
                            NavigationLink(destination: PlayerView(viewModel: viewModel, sound: sound)) {
                                SoundCardView(sound: sound)
                            }
                            .buttonStyle(.plain)
                            .contentShape(Rectangle())
                        }
                    }
                    .padding()
                }
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 60)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { 
                ToolbarItem(placement: .principal) {
                    Text("AmbientNoise")
                        .font(.custom("Charter-Roman", size: 17))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct SoundCardView: View {
    let sound: Sound

    var body: some View {
        VStack {
            Image(sound.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120)
            Text(sound.name)
                .font(.custom("Charter-Roman", size: 20))
                .shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 2) 
                .foregroundColor(.white)
                .padding()
        }
        .overlay(
            ZStack {
                // Color overlay defined by the user
                colorOverlay()
                
                // Vignette effect from PlayerView, adjusted for card size
                RadialGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.5)]),
                    center: .center,
                    startRadius: 20,
                    endRadius: 100
                )
            }
        )
        .cornerRadius(16)
        .clipped()
    }
    
    @ViewBuilder
    private func colorOverlay() -> some View {
        Group {
            if sound.fileName == "red-noise" {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.65, green: 0.25, blue: 0.05).opacity(0.5),
                        Color(red: 0.55, green: 0.20, blue: 0.07).opacity(0.4)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            } else if sound.fileName == "pink-noise" {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.55, green: 0.28, blue: 0.32).opacity(0.3),
                        Color(red: 0.45, green: 0.20, blue: 0.25).opacity(0.4)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.15, green: 0.1, blue: 0.08).opacity(0.2),
                        Color(red: 0.25, green: 0.18, blue: 0.12).opacity(0.1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
    }
}

struct SoundListView_Previews: PreviewProvider {
    static var previews: some View {
        SoundListView()
    }
}
