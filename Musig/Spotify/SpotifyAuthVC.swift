import UIKit
import WebKit
import SafariServices

struct DeviceKey: Codable {
    static var key = ""
}

class SpotifyAuthVC: UIViewController, WKNavigationDelegate, SFSafariViewControllerDelegate {
    
    static let shared = SpotifyAuthVC()

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
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        let component = URLComponents(string: url.absoluteString)
        guard let code = component?.queryItems?.first(where: {$0.name == "code"})?.value else {
            return
        }
        
        webView.isHidden = false
//        webView.load(URLRequest(url: URL(string: "https://www.google.com")!))
        
        let urlString = "https://www.spotify.com"
       
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            present(vc, animated: true)
        }

//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        self.navigationController?.pushViewController(TabBarVC(), animated: true)
        
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        self.navigationController?.pushViewController(TabBarVC(), animated: true)
//        self.navigationController?.modalPresentationStyle = .overCurrentContext
        let root = TabBarVC()
        root.modalPresentationStyle = .overFullScreen
        present(root, animated: true)
//        self.navigationController?.pushViewController(root, animated: true)
        
        
        SpotifyAuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
//                self?.navigationController?.popToRootViewController(animated: true)
//                self?.present(TabBarVC(), animated: true)
//                TabBarVC().navigationController?.pushViewController(TabBarVC(), animated: true)
//                self?.navigationController?.setNavigationBarHidden(true, animated: false)
//                self?.navigationController?.pushViewController(TabBarVC(), animated: true)
                self?.completionHandler?(success)
            }
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
        
        print("safari view controller did finish")
//        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let root = TabBarVC()
        root.modalPresentationStyle = .overFullScreen
        present(root, animated: true)
//        self.navigationController?pushViewController(TabBarVC(), animated: true)
//        TabBarVC().modalPresentationStyle = .overFullScreen
//        self.present(TabBarVC(), animated: true, completion: nil)
        startWebPlayer()
    }
    
    public func startWebPlayer() {
        
//        print(self.navigationController?.viewControllers)
        
        let urlString = "https://open.spotify.com"
      
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
//            present(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        TabBarVC().modalPresentationStyle = .pageSheet
        self.present(TabBarVC(), animated: true, completion: nil)
//        self.navigationController?.pushViewController(TabBarVC(), animated: true)
//        self.navigationController?.popViewController(animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            SpotifyAPICaller.shared.getDeviceIDS() { response in
                DispatchQueue.main.async {
                    switch response {
                    case .success(let model):
                        for i in model {
                            guard case .spotify(let m) = i
                            else { return }
                            if m.name == "Mobile Web Player" {
                                DeviceKey.key = m.id
                                print("LINKDEVICEIDS")
                                print(DeviceKey.key)
                            }
                        }
                    default:
                        print("error")
                    }
                }
            }
        }
    }
    
    public func linkDeviceIDS() {
        SpotifyAPICaller.shared.getDeviceIDS() { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let model):
                    for i in model {
                        guard case .spotify(let m) = i
                        else { return }
                        if m.name == "Mobile Web Player" {
                            DeviceKey.key = m.id
                            print("LINKDEVICEIDS")
                            print(DeviceKey.key)
                        }
                    }
                default:
                    print("error")
                }
            }
        }
    }
}
