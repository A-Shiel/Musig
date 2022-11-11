import Foundation

struct SpotifySearchResultsResponse: Codable {
   
    let tracks: SearchTracksResponse

}

struct SearchTracksResponse: Codable {
    let items: [AudioTrack]
}
