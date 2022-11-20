import Foundation
import UIKit
import MusicKit

final class PlayerPresenter {
    
    static func startPlayback(from viewController: UIViewController, spotify: AudioTrack) {
        let rootVC = PlayerVC()
        // present
        let navVC = UINavigationController(rootViewController: rootVC)
//        viewController.present(navVC, animated: false, completion: nil)
        
//        present(navVC, animated: true)
    }
    
    static func startPlayback(from viewController: UIViewController, apple: Song) {
        let rootVC = PlayerVC()
        // present
        let navVC = UINavigationController(rootViewController: rootVC)
//        viewController.present(navVC, animated: false, completion: nil)
        navVC.pushViewController(rootVC, animated: true)
//        present(navVC, animated: true)
    }
}
