import Foundation
import MusicKit

enum SearchResult: Codable {
    case spotify(model: AudioTrack)
    case apple(model: Song)
}
