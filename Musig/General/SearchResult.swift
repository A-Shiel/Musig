import Foundation
import MusicKit

enum SearchResult {
    case spotify(model: AudioTrack)
    case apple(model: Song)
}
