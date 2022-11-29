import UIKit
import MusicKit; import MediaPlayer
import AVKit; import AVFoundation

class PlayerVC: UIViewController {
    
    lazy var musicTitle: UILabel = {
        let label = UILabel()
//        label.text = "This is label view."
        label.font = UIFont.systemFont(ofSize: 50)
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    lazy var artistTitle: UILabel = {
        let label = UILabel()
//        label.text = "This is label view."
        label.font = UIFont.systemFont(ofSize: 40)
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    func musicTitleConstraints() {
        musicTitle.translatesAutoresizingMaskIntoConstraints = false
        musicTitle.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        musicTitle.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        musicTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        musicTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        
    }
    
    func artistTitleConstraints() {
        artistTitle.translatesAutoresizingMaskIntoConstraints = false
        artistTitle.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        artistTitle.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        artistTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        artistTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
    }
    
    // general
    var togglePlayback = 0

    // spotify
    var spotifyPlayer: AVPlayer?
    var pleyerItem: AVPlayerItem?
    
    // apple
    private let applePlayer = ApplicationMusicPlayer.shared
    private var playerState = ApplicationMusicPlayer.shared.state
    private var isPlayBackQueueSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.addSubview(musicTitle)
//        view.addSubview(artistTitle)
//
//        musicTitleConstraints()
//        artistTitleConstraints()
        
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
   
    // exit forwards backwards
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
        
        // player is paused
        case 0:
            view.backgroundColor = .blue
            togglePlayback = 1
            
            // apple
            // begin playing
            beginPlaying()
            
            // spotify
            // begin playing
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
        
        // player is playing
        case 1:
            // apple
            // stop playing
            stopApplePlayback()
            
            
            // spotify
            // stop playing
            
            view.backgroundColor = .yellow
            togglePlayback = 0
        default:
            print("error with playback")
        }
    }
}


extension PlayerVC {
    
    // start playback for spotify
    // FROM PLAYLISTVC
    func startPlayback(spotify: AudioTrack) {
        
        musicTitle.text = spotify.name
        self.view.addSubview(musicTitle)
        musicTitleConstraints()
        artistTitle.text = spotify.artists[0].name
        self.view.addSubview(artistTitle)
        artistTitleConstraints()
        
        
        let trackName = ["uris": ["spotify:track:" + spotify.id]]
        stopApplePlayback()
        SpotifyAPICaller.shared.startPlayback(with: trackName) { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let r):
                    print(r)
                    print("SUCCESS")
                default:
                    print("broken")
                }
            }
        }
    }
    
    // resume playback for spotify
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
    
    // change methodology of spotifyerrorpopup
    func spotifyErrorPopup() {
        let title = "Error"
        let alert = UIAlertController(title: title, message: "Please Reopen Musig After Spotify Launches", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: { action in
            // call SPOTIFYAPICALLER getDeviceIDs()
            UIApplication.shared.open(URL(string: "spotify:home")!, options: [:], completionHandler: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // apple playback
    // FROM PLAYLISTVC
    // rework
    func startPlayback(apple: Song) {

        musicTitle.text = apple.title
        self.view.addSubview(musicTitle)
        musicTitleConstraints()
        artistTitle.text = apple.artistName
        self.view.addSubview(artistTitle)
        artistTitleConstraints()
        
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
    
    // apple stop playback
    func stopApplePlayback() {
        applePlayer.pause()
        togglePlayback = 0
    }
    
    // apple play playback
    func beginPlaying() {
        Task {
            do {
                try await applePlayer.play()
            } catch {
                print("\(error)")
            }
        }
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
