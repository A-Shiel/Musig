import Foundation
import UIKit

final class SpotifyAPICaller {
    static let shared = SpotifyAPICaller()

    private init() {}

    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }

    enum APIError: Error {
        case failedToGetData
    }

    // MARK: - Search

    public func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL+"/search?limit=5&type=track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"),
            type: .GET
        ) { request in
            print(request.url?.absoluteString ?? "none")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }

                do {
                    // prints the json response. store it in an array and put data into a tableview
                    // let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let result = try JSONDecoder().decode(SpotifySearchResultsResponse.self, from: data)
                    var searchResults: [SearchResult] = []
                    searchResults.append(contentsOf: result.tracks.items.compactMap({ SearchResult.spotify(model: $0) }))
                    print(result)
                    
                    completion(.success(searchResults))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - DeviceID
    public func getDeviceIDS(completion: @escaping (Result<[DeviceResult], Error>) -> Void) {
        createRequest(with:
                        URL(string: Constants.baseAPIURL+"/me/player/devices"),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
//                     let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print(json)

                    let result = try JSONDecoder().decode(SpotifyDeviceResultsResponse.self, from: data)
                    print(UIDevice.current.identifierForVendor!.uuidString)
                    var deviceResults: [DeviceResult] = []
                    deviceResults.append(contentsOf: result.devices.compactMap({ DeviceResult.spotify(model: $0)
                    }))
                    print(result)
                    completion(.success(deviceResults))
                    
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
//    public func getDeviceIDS(completion: @escaping (Result<[DeviceResult], Error>) -> Void) {
//        createRequest(
//            with: URL(string: Constants.baseAPIURL+"/me/player/devices"),
//            type: .GET
//        ) { request in
//            print(request.url?.absoluteString ?? "none")
//            let task = URLSession.shared.dataTask(with: request) { data, _, error in
//                guard let data = data, error == nil else {
//                    completion(.failure(APIError.failedToGetData))
//                    return
//                }
//
//                do {
////                     prints the json response. store it in an array and put data into a tableview
//                     let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                     print(json)
////                    let result = try JSONDecoder().decode(SpotifySearchResultsResponse.self, from: data)
////                    var searchResults: [SearchResult] = []
////                    searchResults.append(contentsOf: result.tracks.items.compactMap({ SearchResult.spotify(model: $0) }))
//
////                    let result = try JSONDecoder().decode(SpotifyDeviceResultsResponse.self, from: data)
////                    var deviceResults: [DeviceResult] = []
////                    deviceResults.append(contentsOf: result.items.compactMap({ DeviceResult.spotify(model: $0) }))
////                    completion(.success(deviceResults))
////                    print(result)
//
////                    completion(.success(searchResults))
////                    print(result)
//                }
//                catch {
//                    print(error.localizedDescription)
//                    completion(.failure(error))
//                }
//            }
//            task.resume()
//        }
//    }
    
    // MARK: Spotify Playback
    
    public func startPlayback(with trackName: [String: [String]], completion: @escaping (Result<Int, Error>) -> Void) {
        
        let json = trackName
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        createRequest(
            with: URL(string: Constants.baseAPIURL+"/me/player/play?device_id=\(DeviceKey.key)"),
            //            with: URL(string: Constants.baseAPIURL+"/me/player/play?device_id=4a802bfefe174020009662aedcce4c15f0d3d0b7"),
            httpBody: jsonData,
            type: .PUT
        ) { request in
            print(request.url?.absoluteString ?? "none")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                //                guard let data = data, error == nil else {
                //                    completion(.failure(APIError.failedToGetData))
                //                    return
                //                }
                guard let response = response as? HTTPURLResponse, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    // cast reponse to int
                    // store it
                    let responseHTML = response.statusCode
                    print(responseHTML)
                    
                    if responseHTML == 204 {
                        completion(.success(responseHTML))
                    } else {
                        completion(.failure(APIError.failedToGetData))
                    }
                }
            }
            task.resume()
        }
    }
    
    public func resumePlayback(completion: @escaping (Result<Int, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL+"/me/player/play?device_id=\(DeviceKey.key)"),
//            with: URL(string: Constants.baseAPIURL+"/me/player/play"),
            type: .PUT
        ) { request in
            print(request.url?.absoluteString ?? "none")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let response = response as? HTTPURLResponse, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    // cast reponse to int
                    // store it
                    let responseHTML = response.statusCode
                    
                    if responseHTML == 204 {
                        completion(.success(responseHTML))
                    } else {
                        completion(.failure(APIError.failedToGetData))
                    }
                }
            }
            task.resume()
        }
    }
    
    public func pausePlayback(completion: @escaping (Result<Int, Error>) -> Void) {
        
        createRequest(
            with: URL(string: Constants.baseAPIURL+"/me/player/pause?device_id=\(DeviceKey.key)"),
            //            with: URL(string: Constants.baseAPIURL+"/me/player/play?device_id=4a802bfefe174020009662aedcce4c15f0d3d0b7"),
            type: .PUT
        ) { request in
            print(request.url?.absoluteString ?? "none")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                //                guard let data = data, error == nil else {
                //                    completion(.failure(APIError.failedToGetData))
                //                    return
                //                }
                guard let response = response as? HTTPURLResponse, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    // cast reponse to int
                    // store it
                    let responseHTML = response.statusCode
                    
                    if responseHTML == 204 {
                        completion(.success(responseHTML))
                    } else {
                        completion(.failure(APIError.failedToGetData))
                    }
                }
            }
            task.resume()
        }
    }
        
        

    
//                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//                if let responseJSON = responseJSON as? [String: Any] {
//                    print("RESPONSE")
//                    print(responseJSON)
//                }
//
//                if let response = response as? HTTPURLResponse {
//                    print("CALLER \(response.statusCode)")
//                    spotifyHTTPError.spotifyHTTPResponse = response.statusCode
//                }
//
//                completion(.success(request))
//                print(completion(.success(request)))
////
//                if let error = error {
//                    print("CALLER \(error)")
//                }

//
//                if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                    print("CALLER \(dataString)")
//                }
//    // MARK: - Start Playback
//    public func startPlayback(with url: String) {
//        print("Started Spotify Playback")
//        createRequest(
//            with: URL(string: Constants.baseAPIURL+"/me/player/play=\(url)"),
//            type: .PUT
//        )
//    }

    // MARK: - Private

    enum HTTPMethod: String {
        case GET
        case PUT
        case POST
        case DELETE
    }

    private func createRequest(with url: URL?, httpBody: Data? = nil, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        SpotifyAuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)",
                             forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            request.httpBody = httpBody
            completion(request)
        }
    }
}
