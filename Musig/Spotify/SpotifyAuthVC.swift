import UIKit
import WebKit
import SafariServices

struct DeviceKey: Codable {
    static var key = ""
}

class SpotifyAuthVC: UIViewController, WKNavigationDelegate, SFSafariViewControllerDelegate {
    
    static let shared = SpotifyAuthVC()
    
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        guard let url = SpotifyAuthManager.shared.signInURL else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    public var completionHandler: ((Bool) -> Void)?
    
    private let webView: WKWebView = {
        let conf = WKWebViewConfiguration()
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        conf.defaultWebpagePreferences = prefs
        conf.allowsInlineMediaPlayback = true
        conf.allowsAirPlayForMediaPlayback = true
        conf.allowsPictureInPictureMediaPlayback = true
        conf.mediaTypesRequiringUserActionForPlayback = []
        
        let webView = WKWebView(frame: .zero, configuration: conf)
        
        return webView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
//    func initiateSafariVC() {
//        let safariVC = SFSafariViewController(url: NSURL(string: "https://open.spotify.com")! as URL)
//        safariVC.delegate = self
//        self.present(safariVC, animated: true)
//    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        let component = URLComponents(string: url.absoluteString)
        guard let code = component?.queryItems?.first(where: {$0.name == "code"})?.value else {
            return
        }
        
        webView.isHidden = false
        
        SpotifyAuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.completionHandler?(success)
            }
        }
    }
   
//    user dismiss
//    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
//        dismiss(animated: true)
//
//        print("safari view controller did finish loaded")
//        startWebPlayer()
//    }
    
//    public func startWebPlayer() {
//
//      timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
//        self.navigationController?.popToRootViewController(animated: true)
//        self.navigationController?.popToRootViewController(animated: true)
//        self.navigationController?.pushViewController(TabBarVC(), animated: true)
//        print(navigationController?.viewControllers)
//        RootVC.shared.initiateSafariVC()
//        let safariVC = SFSafariViewController(url: NSURL(string: "https://open.spotify.com")! as URL)
//        safariVC.delegate = self
//        TabBarVC().present(safariVC, animated: true)
//
//
//        self.navigationController?.popToRootViewController(animated: true)
//        let safariVC = SFSafariViewController(url: NSURL(string: "https://open.spotify.com")! as URL)
//        self.present(safariVC, animated: true)
//        safariVC.view.isHidden = false
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//            SpotifyAPICaller.shared.getDeviceIDS() { response in
//                DispatchQueue.main.async {
//                   switch response {
//                    case .success(let model):
//                        for i in model {
//                            guard case .spotify(let m) = i
//                            else { return }
//                            if m.name == "Mobile Web Player" {
//                                DeviceKey.key = m.id
//                                print("LINKDEVICEIDS")
//                                print(DeviceKey.key)
//                            }
//                        }
//                    default:
//                        print("error")
//                    }
//                }
//            }
//        }
//    }
    
    func getDeviceIDS() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            SpotifyAPICaller.shared.getDeviceIDS() { response in
                DispatchQueue.main.async {
                   switch response {
                    case .success(let model):
                        for i in model {
                            guard case .spotify(let m) = i
                            else { return }
                            if m.name == "Mobile Web Player" {
                                DeviceKey.key = m.id
                                print("DEVICE KEY SUCCESSFULLY RETURNED = \(DeviceKey.key)")
                            }
                        }
                    default:
                        print("error")
                    }
                }
            }
        }
    }
    
//    @objc func timerAction() {
//        let root = RootVC()
//        root.modalPresentationStyle = .overFullScreen
//        self.present(root, animated: true)
//    }
//
//    public func linkDeviceIDS() {
//        SpotifyAPICaller.shared.getDeviceIDS() { response in
//            DispatchQueue.main.async {
//                switch response {
//                case .success(let model):
//                    for i in model {
//                        guard case .spotify(let m) = i
//                        else { return }
//                        if m.name == "Mobile Web Player" {
//                            DeviceKey.key = m.id
//                            print("LINKDEVICEIDS")
//                            print(DeviceKey.key)
//                        }
//                    }
//                default:
//                    print("error")
//                }
//            }
//        }
//    }
}
