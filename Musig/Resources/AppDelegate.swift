import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window:UIWindow?
    static let identifier = "playlist"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        appLaunched()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = TabBarVC()
        self.window = window
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("terminate")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(PlaylistArray.array) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: AppDelegate.identifier)
        }
    }
    
    func appLaunched() {
        print("app launched")
        let defaults = UserDefaults.standard
        if let savedPlaylist = defaults.object(forKey: AppDelegate.identifier) as? Data {
            let decoder = JSONDecoder()
            if let loadedPlaylist = try? decoder.decode([SearchResult].self, from: savedPlaylist) {
                PlaylistArray.array = loadedPlaylist
            }
        }
    }
}

