import UIKit
import MusicKit

class PlayerVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeDownFromTop = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        swipeDownFromTop.direction = .down
        view.addGestureRecognizer(swipeDownFromTop)
        
        view.backgroundColor = .systemPink
    }
    
    func startPlayback(apple: Song) {
        
    }
    
    func startPlayback(spotify: AudioTrack) {
        
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        let vc = PlayerVC()
        if sender.direction == .down {
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.popViewControllerFromBottom(controller: vc)
//            navigationController?.pushViewControllerFromTop(controller: vc)
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
