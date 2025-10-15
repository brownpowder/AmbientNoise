
import SwiftUI

struct SoundListView: View {
    @StateObject private var viewModel = SoundViewModel()

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

                List {
                    ForEach(viewModel.sounds) { sound in
                        NavigationLink(destination: PlayerView(viewModel: viewModel, sound: sound)) {
                            HStack(spacing: 15) {
                                Image(sound.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                                    .clipped()

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(sound.name)
                                        .font(.custom("Futura-Bold", size: 18))
                                        .foregroundColor(.white.opacity(0.9))

                                    Text(sound.description)
                                        .font(.custom("Futura-Medium", size: 14))
                                        .foregroundColor(.white.opacity(0.7))
                                        .lineLimit(2)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparatorTint(.white.opacity(0.2))
                    }
                }
                .listStyle(.plain)
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 60)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { 
                ToolbarItem(placement: .principal) {
                    Text("AmbientNoise")
                        .font(.custom("Futura-Medium", size: 17))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct SoundListView_Previews: PreviewProvider {
    static var previews: some View {
        SoundListView()
    }
}
