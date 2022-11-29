import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
//        window.rootViewController = TabBarVC()
        window.rootViewController = RootVC()
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if SpotifyAuthManager.shared.isSignedIn {
            print("USER IS SIGNED IN TO SPOTIFY")
//            SpotifyAuthVC.shared.startWebPlayer()
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let firstUrl = URLContexts.first?.url else {
            return
        }

        print(firstUrl.absoluteString)
    }
}

//extension SceneDelegate {
//    static var shared: SceneDelegate {
//        return UIApplication.shared.delegate as! SceneDelegate
//    }
//    var rootViewController: RootViewController {
//        return window!.rootViewController as! RootViewController
//    }
//}

