import UIKit
import AVFAudio

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window:UIWindow?
    static let playlistIdentifier = "playlist"
    static let deviceIdentifier = "device"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // disable status bar
//        application.isStatusBarHidden = true
        
        appLaunched()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
//        window.rootViewController = TabBarVC()
        window.rootViewController = RootVC()
        self.window = window
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("terminate")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(PlaylistArray.array) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: AppDelegate.playlistIdentifier)
        }
        if let encoded = try? encoder.encode(DeviceKey.key) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: AppDelegate.deviceIdentifier)
        }
    }

    func appLaunched() {
        print("app launched")
        let defaults = UserDefaults.standard
        if let savedPlaylist = defaults.object(forKey: AppDelegate.playlistIdentifier) as? Data {
            let decoder = JSONDecoder()
            if let loadedPlaylist = try? decoder.decode([SearchResult].self, from: savedPlaylist) {
                PlaylistArray.array = loadedPlaylist
            }
        }
        
        if let savedDeviceKey = defaults.object(forKey: AppDelegate.deviceIdentifier) as? Data {
            let decoder = JSONDecoder()
            if let loadedDevice = try? decoder.decode(String.self, from: savedDeviceKey) {
                DeviceKey.key = loadedDevice
            }
        }
        
//        let audioSession = AVAudioSession.sharedInstance()
//         do {
////            try audioSession.setCategory(.playback)
//            try audioSession.setActive(true)
//            print("audio initialized")
//         } catch {
//             print("Setting category to AVAudioSessionCategoryPlayback failed.")
//         }
    }
}

