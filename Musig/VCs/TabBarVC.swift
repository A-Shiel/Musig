import UIKit
import SafariServices

class TabBarVC: UITabBarController, SFSafariViewControllerDelegate {
    
    static let shared = TabBarVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .label
        UINavigationBar.appearance().prefersLargeTitles = true
        viewControllers = [createLoginNC(), createSearchNC(), createPlaylistNC()]
        configureItemImages()
    }
    
    func configureItemImages() {
        guard let items = self.tabBar.items else { return }
        let images = ["person", "magnifyingglass", "play"]
        
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: images[i])
        }
    }
    
    func createPlaylistNC() -> UINavigationController {
        let pv = PlaylistVC()
        pv.title = "Playlist"
        return UINavigationController(rootViewController: pv)
    }
    
    func createSearchNC() -> UINavigationController {
        let sv = SearchVC()
        sv.title = "Search"

        return UINavigationController(rootViewController: sv)
    }
    
    func createLoginNC() -> UINavigationController {
        let lv = LoginVC()
        lv.title = "Login"

        return UINavigationController(rootViewController: lv)
    }
    
//    func loadSFVInBackground() {
//        let safariVC = SFSafariViewController(url: NSURL(string: "https://open.spotify.com")! as URL)
//        safariVC.delegate = self
//
//        DispatchQueue.main.async { [weak self] in
//            self?.present(safariVC, animated: true, completion: nil)
//        }
//    }
}
