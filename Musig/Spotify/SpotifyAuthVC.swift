import UIKit
import WebKit

class SpotifyAuthVC: UIViewController, WKNavigationDelegate {
    
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
        
        webView.isHidden = true
        
        SpotifyAuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
        }
    }
}
