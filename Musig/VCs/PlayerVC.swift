import UIKit
import MusicKit

class PlayerVC: UIViewController {
    
    var togglePlayback = 0
    
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
    
    func startPlayback(spotify: AudioTrack)  {
        print(spotify.name)
        print(spotify.artists[0].name)
    }
    
    func startPlayback(apple: Song) {
        print(apple.title)
        print(apple.artistName)
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        
        let vc = PlayerVC()
       
        // exit
        if sender.direction == .down {
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.popViewControllerFromBottom(controller: vc)
//            navigationController?.pushViewControllerFromTop(controller: vc)
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
        case 1:
            view.backgroundColor = .yellow
            togglePlayback = 0
        default:
            print("error with playback")
        }
//        if togglePlayback == 0 {
//            view.backgroundColor = .blue
//            togglePlayback = 1
//        } else if togglePlayback == 1 {
//            view.backgroundColor = .yellow
//            togglePlayback = 0
//        }
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
