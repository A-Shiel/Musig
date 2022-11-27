import UIKit
import MusicKit; import MediaPlayer
import AVKit; import AVFoundation

// this is the array that we are referencing instead
//
//struct PlaylistArray: Codable {
//    static var array = [SearchResult]()
//}

class PlayerVC: UIViewController {
    // general
    var togglePlayback = 0

    // spotify
    var spotifyPlayer: AVPlayer?
    var pleyerItem: AVPlayerItem?
//    var spotifyURL = ""
    // apple
    private let applePlayer = ApplicationMusicPlayer.shared
    private var playerState = ApplicationMusicPlayer.shared.state
    private var isPlayBackQueueSet = false
//    private var spotify: AudioTrack?
//    private var apple: Song?
//    var appleURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeDownFromTop = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        swipeDownFromTop.direction = .down
        view.addGestureRecognizer(swipeDownFromTop)
       
        let swipeLeftToRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        swipeLeftToRight.direction = .right
        view.addGestureRecognizer(swipeLeftToRight)
        
        let swipeRightToLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        swipeRightToLeft.direction = .left
        view.addGestureRecognizer(swipeRightToLeft)
        
        let screenTapped = UITapGestureRecognizer(target: self, action: #selector(handleTaps(_:)))
        view.addGestureRecognizer(screenTapped)
       
        view.backgroundColor = .systemBackground
    }
    
    //FIX BROKEN!
    // occurs when each song is played from PlaylistVC
    func startPlayback(spotify: AudioTrack) {
        //            let url = "uris=[spotify:track:" + spotify.id + "]"
        //            let url = "4a802bfefe174020009662aedcce4c15f0d3d0b7"
        //            let url = "spotify:track:" + spotify.external_urls["Spotify"]
        
        let trackName = ["uris": ["spotify:track:" + spotify.id]]
        stopApplePlayback()
        SpotifyAPICaller.shared.startPlayback(with: trackName) { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let r):
                    print(r)
                    print("SUCCESS")
                default:
//                    self.spotifyErrorPopup()
                    print("broken")
                }
            }
        }
    }
    
    func resumePlayback() {
        SpotifyAPICaller.shared.resumePlayback() { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let r):
                    print(r)
                    print("SUCCESS")
                default:
                    print("ERROR")
                }
            }
        }
    }
    
    func spotifyErrorPopup() {
        let title = "Error"
        let alert = UIAlertController(title: title, message: "Please Reopen Musig After Spotify Launches", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: { action in
            // call SPOTIFYAPICALLER getDeviceIDs()
            UIApplication.shared.open(URL(string: "spotify:home")!, options: [:], completionHandler: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
//        print("BIG BOOTY")
//        print(spotifyHTTPError.spotifyHTTPResponse)
//        if spotifyHTTPError.spotifyHTTPResponse != 204 {
//            let title = "Error"
//            let alert = UIAlertController(title: title, message: "Please open up Spotify App on your Device", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//        print("BIG BOOTY")
//        print(spotifyHTTPError.spotifyHTTPResponse)
//        if spotifyHTTPError.spotifyHTTPResponse != 204 {
//            let title = "Error"
//            let alert = UIAlertController(title: title, message: "Please open up Spotify App on your Device", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }

//    Task {
//        SpotifyAPICaller.shared.search(with: query) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let results):
//                    //                    resultsController.update(with: results)
//                    self.array.append(contentsOf: results)
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
    
    // apple playback
    func startPlayback(apple: Song) {
        if togglePlayback == 0 {
            if !isPlayBackQueueSet {
                applePlayer.queue = [apple]
                isPlayBackQueueSet = true
                beginPlaying()
                togglePlayback = 1
            } else {
                beginPlaying()
                togglePlayback = 1
            }
            } else {
            applePlayer.pause()
                togglePlayback = 0
        }
    }
    
    func stopApplePlayback() {
        applePlayer.pause()
        togglePlayback = 0
    }
    
    // begin playing apple music song
    func beginPlaying() {
        Task {
            do {
                try await applePlayer.play()
            } catch {
                print("\(error)")
            }
        }
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        
        let vc = PlayerVC()
       
        // exit
        if sender.direction == .down {
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.popViewControllerFromBottom(controller: vc)
        }
        
        // skip forward
        if sender.direction == .left {
            view.backgroundColor = .systemBlue
        }
        
        // skip backward
        if sender.direction == .right {
            view.backgroundColor = .systemRed
        }
    }
    
    // play and pause
    @objc func handleTaps(_ sender: UITapGestureRecognizer) {

        switch togglePlayback {
        case 0:
            view.backgroundColor = .blue
            togglePlayback = 1
            
            // apple
            // beginPlaying()
            
            // spotify
            SpotifyAPICaller.shared.resumePlayback() { response in
                DispatchQueue.main.async {
                    switch response {
                    case .success(let r):
                        print(r)
                        print("SUCCESS")
                    default:
                        print("failure")
                    }
                }
            }
            
        case 1:
            view.backgroundColor = .yellow
            togglePlayback = 0
            
            // apple
//            applePlayer.pause()
            
            // spotify
            SpotifyAPICaller.shared.pausePlayback() { response in
                DispatchQueue.main.async {
                    switch response {
                    case .success(let r):
                        print(r)
                        print("SUCCESS")
                    default:
                        print("failure")
                    }
                }
            }
        default:
            print("error with playback")
        }
    }
}

extension UINavigationController {
    func pushViewControllerFromTop(controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        pushViewController(controller, animated: false)
    }
    
    func popViewControllerFromBottom(controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
}
