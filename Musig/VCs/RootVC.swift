import UIKit
import SafariServices


class RootVC: UIViewController, SFSafariViewControllerDelegate {
    
    static let shared = RootVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadViewIfNeeded()
        
        let parent = self
        let child = TabBarVC()

        // First, add the view of the child to the view of the parent
        parent.view.addSubview(child.view)

        // Then, add the child to the parent
        parent.addChild(child)

        // Finally, notify the child that it was moved to a parent
        child.didMove(toParent: parent)
    }
  
   
//    func initiateSafariVC() {
//        let safariVC = SFSafariViewController(url: NSURL(string: "https://open.spotify.com")! as URL)
//        safariVC.delegate = self
//        present(safariVC, animated: true)
//        safariVC.view.isHidden = true
//    }
}
