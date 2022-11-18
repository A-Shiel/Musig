import Foundation
import MusicKit

final class AMCaller {
    
    static let shared = AMCaller()
    
    public init() {}

    func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) async -> MusicCatalogSearchResponse? {
            do {
                let types: [MusicCatalogSearchable.Type] = [Song.self]
                var request = MusicCatalogSearchRequest(term: query, types: types)
                request.limit = 5
                
                let response = try await request.response()
                
                var searchResults: [SearchResult] = []
                searchResults.append(contentsOf: response.songs.compactMap({ SearchResult.apple(model: $0) }))
                
                completion(.success(searchResults))
                
                return response
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
                return nil
            }
    }
}

