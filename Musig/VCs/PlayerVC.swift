import UIKit
import MusicKit; import MediaPlayer
import AVKit; import AVFoundation

/*
 LOGIC
 
 check if apple song or spotify song
 if apple song
 set timer to apple (duration)
 if spotify song
 set timer to spotify (duration)
 play()
 
 if toggleplayback = 1 initiate timer
 if toggleplayback = 0 stop timer
 
 if apple song is playing and timer = 0
 skip to next track in array
 
 if spotify song is playing and timer = 0
 skip to next track in array
 
 VARIABLES
 playerIsPlaying
 currentIndexOfArray
 songTimer
 
 METHODS
 
 - start spotify song
 - start apple song
 
 - resume spotify song
 - resume apple song
 
 - pause spotify song
 - pause apple song
 
 - skip to next track
 - go back to previous track
 
 - close the player
 
 */

// GESTURES
class PlayerVC: UIViewController {
    
    static let shared = PlayerVC()
    
    // VARIABLES
    var playerIsPlaying = true
    let array = PlaylistArray.array
    var currentIndex = 0
    var initialIndex = 0
    // on an apple object
    var appleToggle = false
    // on a spotify object
    var spotifyToggle = false
    var duration = 0
    
    
    // APPLE SPECIFIC
    private let applePlayer = ApplicationMusicPlayer.shared
    private var playerState = ApplicationMusicPlayer.shared.state
    private var isPlayBackQueueSet = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupGestures()
    }

    // runs every time the player shows on screen
    override func viewWillAppear(_ animated: Bool) {
        print("Moved To -> Player")
    }
    
    // initializes the gestures
    func setupGestures() {
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
    }
    
    // skip, back, or exit
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        
        // exit
        if sender.direction == .down {
            exitGesture()
        }
        
        // skip
        if sender.direction == .left {
            skipGesture()
        }
        
        // back
        if sender.direction == .right {
            backGesture()
        }
    }
    
    
    
    
    
  // REAL CODE BELOW
    

    // PlaylistVC call
    func jumpOffPlayer() {
        currentIndex = initialIndex
        checkIfSpotifyOrApple()
        playerIsPlaying = true
    }
   
    // play, pause
    @objc func handleTaps(_ sender: UITapGestureRecognizer) {
        
        print("handleTaps \(playerIsPlaying)")

        if playerIsPlaying == false {
            
            playerResume()
            playerIsPlaying = true
            print("playerResume")

        }
        
        else if playerIsPlaying == true {
            
            playerPause()
            playerIsPlaying = false
            print("playerPause")
           
        }
    }
    
    func exitGesture() {
       // CLOSE PLAYER
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.popViewControllerFromBottom(controller: self)
    }
   
    func skipGesture() {
        // CHECK APPLE OR SPOTIFY
        
        // IF APPLE PLAY APPLE
        
        // IF SPOTIFY PLAY SPOTIFY
    }
    
    func backGesture() {
        // CHECK APPLE OR SPOTIFY
        
        // IF APPLE PLAY APPLE
        
        
        // IF SPOTIFY PLAY SPOTIFY
    }
    
    func playerPause() {
        
        print("playerPause \(appleToggle)")
        print("playerPause \(spotifyToggle)")

        
        
        // IF APPLE -> PAUSE APPLE
        if appleToggle == true {
            applePause()
        }
        
        // IF SPOTIFY -> PAUSE SPOTIFY
        else if spotifyToggle == true {
            spotifyPause()
        }
    }
    
    func playerResume() {
        
        print("playerResume \(appleToggle)")
        print("playerResume \(spotifyToggle)")
        
        if appleToggle == true {
            playerIsPlaying = true
            appleResume()
        }
        else if spotifyToggle == true {
            playerIsPlaying = true
            spotifyResume()
        }
    }
    
    func checkIfSpotifyOrApple() {
        print("checkifspotifyorapple \(playerIsPlaying)")
        let result = array[currentIndex]
        
        switch result {
        case .spotify(let model):
            print("case spotify")
            spotifyToggle = true
            appleToggle = false
            spotifyPlay(spotify: model)
            print(spotifyToggle)
            print(appleToggle)
            print("****")


            
        case .apple(let model):
            print("case apple")
            appleToggle = true
            spotifyToggle = false
            applePlay(apple: model)
            print(spotifyToggle)
            print(appleToggle)
            print("****")

        }
    }
}

// apple and spotify specific methods
extension PlayerVC {
    

    func spotifyPlay(spotify: AudioTrack) {
        let song = ["uris": ["spotify:track:" + spotify.id]]
        SpotifyAPICaller.shared.startPlayback(with: song) { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let r):
                    print("spotifyPlay passed")
                default:
                    print("spotifyPlay failed")
                }
            }
        }
    }
    
    func applePlay(apple: Song) {
        if !isPlayBackQueueSet {
            applePlayer.queue = [apple]
            isPlayBackQueueSet = true
            Task {
                do {
                    try await applePlayer.play()
                    print("applePlay passed")
                } catch {
                    print("applePlay failed")
                }
            }
        }
    }
    
    func spotifyPause() {
        SpotifyAPICaller.shared.pausePlayback() { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let r):
                    print("spotifyPause passed")
                default:
                    print("spotifyPause failed")
                }
            }
        }
    }
    
    func applePause() {
        applePlayer.pause()
    }
    
    func spotifyResume() {
        SpotifyAPICaller.shared.resumePlayback() { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let r):
                    print("spotifyResume passed")
                default:
                    print("spotifyResume failed")
                }
            }
        }
    }
    
    func appleResume() {
        isPlayBackQueueSet = true
        Task {
            do {
                try await applePlayer.play()
                print("applePlay passed")
            } catch {
                print("applePlay failed")
            }
        }
    }
}

// timer
extension PlayerVC {
    func durationFinished() {
        // if there is a next track
        // if currentIndex += 1 < array.count
        // currentIndex += 1
        // set track to next track
        // skipGesture()
        //
    }
}

extension UINavigationController {
    
    func pushViewControllerFromTop(controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        pushViewController(controller, animated: false)
    }
    
    func popViewControllerFromBottom(controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
}
