import UIKit
import SafariServices

class TabBarVC: UITabBarController, UITabBarControllerDelegate, SFSafariViewControllerDelegate {
    
    static let shared = TabBarVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.delegate = self
        tabBar.tintColor = .label
        UINavigationBar.appearance().prefersLargeTitles = true
        viewControllers = [createLoginNC(), createSearchNC(), createPlaylistNC(), createHostNC()]
        configureItemImages()
    }
    
    func configureItemImages() {
        guard let items = self.tabBar.items else { return }
        let images = ["person", "magnifyingglass", "play", "square.3.layers.3d.down.left"]
        
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
    
    func createHostNC() -> UINavigationController {
        let hv = HostVC()
        hv.title = "Host"
        
        return UINavigationController(rootViewController: hv)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)
        if selectedIndex == 0 {
            print("-> Login")
        }
        if selectedIndex == 1 {
            print("-> Search")
        }
        if selectedIndex == 2 {
            print("-> Playlist")
        }
        if selectedIndex == 3 {
            print("-> Host")
        }
    }
}
