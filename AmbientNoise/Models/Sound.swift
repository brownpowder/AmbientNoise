
import Foundation

struct Sound: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let fileName: String
    let imageName: String
    let description: String
    let isPremium: Bool
}
