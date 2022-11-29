import UIKit
import WebKit
import SafariServices

class HostVC: UIViewController, WKUIDelegate {
    
    static let shared = HostVC()
    
    var injectedChecker = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Get Device Key", style: .plain, target: self, action: #selector(getDeviceKey))
    }
    
    // Function that gets called everytime the tabbar item is tapped.
    override func viewWillAppear(_ animated: Bool) {
        print("HOST VC APPEARED")
        if injectedChecker == 0 {
            if SpotifyAuthManager.shared.isSignedIn {
                injectSpotifyPlayer()
                injectedChecker = 1
            } else {
                alertSpotifyPlayer()
            }
        }
    }
    
    func injectSpotifyPlayer() {
        print("injectSpotifyPlayer")
        let svc = SFSafariViewController(url: NSURL(string: "https://open.spotify.com")! as URL)
        var safariView:UIView?
        let containerView = UIView()
        self.addChild(svc)
        svc.didMove(toParent: self)
        svc.view.frame = view.frame
        containerView.frame = view.frame
        safariView = svc.view
        view.addSubview(safariView!)
        view.addSubview(containerView)
        view.bringSubviewToFront(safariView!)
        view.sendSubviewToBack(safariView!)
    }
    
    func alertSpotifyPlayer() {
        print("alertSpotifyPlayer")
        let title = "Error Loading Host"
        let alert = UIAlertController(title: title, message: "Host is only available for logged in Spotify users. Please retry if you have logged in.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deviceKeyVerified() {
        print("deviceKeyVerified")
        let title = "Device Key Verified!"
        let alert = UIAlertController(title: title, message: "Time to go play your favorite tracks.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deviceKeyRetry() {
        let title = "Unsuccessfull Attempt at Verifying Device"
        let alert = UIAlertController(title: title, message: "Please make sure that you have started audio from the host.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func getDeviceKey() {
        print("fetching device key")
        SpotifyAuthVC.shared.getDeviceIDS()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if DeviceKey.key != "" {
                self.deviceKeyVerified()
            } else {
                self.deviceKeyRetry()
            }
        }
    }
}

