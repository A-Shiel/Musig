import UIKit
import MusicKit
import SafariServices
import WebKit
import AVFoundation


class LoginVC: UIViewController, SFSafariViewControllerDelegate, WKNavigationDelegate, WKUIDelegate {
    
    
    var myTableView: UITableView!
    var list: [String] = ["Spotify", "Apple Music"]
    
    var player: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        myTableView = UITableView()
        configureMyTableView()
        view.addSubview(myTableView)
        myTableView.register(LoginCell.classForCoder(), forCellReuseIdentifier: LoginCell.identifier)
        myTableViewConstraints()
    }
    
    func configureMyTableView() {
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorColor = .clear
    }
    
    func myTableViewConstraints() {
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        myTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
}

extension LoginVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LoginCell.identifier) as! LoginCell
        
        cell.delegate = self
        cell.btn.setTitle(list[indexPath.row], for: .normal)
        cell.configureBtn(with: list[indexPath.row])
        cell.btn.backgroundColor = .systemBackground
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
            return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }
}


extension LoginVC: LoginCellDelegate {
    func didTapButton(with title: String) {
        if title == "Spotify" {
            if SpotifyAuthManager.shared.isSignedIn {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                let vc = SpotifyAuthVC()
                vc.completionHandler = { [weak self] success in
                    DispatchQueue.main.async {
                        self?.handleSignIn(success: success)
                    }
                }
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if title == "Apple Music" {
            Task {
                let status = await MusicAuthorization.request()
                switch status {
                case .authorized:
                    print("authorized")
                    SearchVC.shared.appleMusicCanSearch = true
                case .notDetermined:
                    print("notDetermined")
                case .denied:
                    print("denied")
                case .restricted:
                    print("restricted")
                @unknown default:
                    print("error")
                }
            }
        }
        
//        if title == "YouTube" {
//            
//        }
    }
    
    func initiateWebPlayerInBackground() {
        // WEBVIEW
//
//        var webView: WKWebView!
//        webView = WKWebView(frame: view.frame)
//        webView.uiDelegate = self
//        view.addSubview(webView)
//
//        let myURL = URL(string: "https://google.com")
//        let myRequest = URLRequest(url: myURL!)
//        webView.load(myRequest)
       
        // SAFARI
        //        let svc = SFSafariViewController(url: NSURL(string: "https://open.spotify.com")! as URL)
        //        svc.playAudio()
        //        var safariView:UIView?
        //        let containerView = UIView()
        //        self.addChild(svc)
        //        svc.didMove(toParent: self)
        //        svc.view.frame = view.frame
        //        containerView.frame = view.frame
        //        safariView = svc.view
        //        view.addSubview(safariView!)
        //        view.addSubview(containerView)
        //        view.bringSubviewToFront(safariView!)
        //        view.sendSubviewToBack(safariView!)
    }
    

    func spotifyAlertReturn() {
        let title = "Spotify Auth"
        let alert = UIAlertController(title: title, message: "Please Reopen Musig After Spotify Launches", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: { action in
        // call SPOTIFYAPICALLER getDeviceIDs()
             UIApplication.shared.open(URL(string: "spotify:home")!, options: [:], completionHandler: nil)
    }))
    present(alert, animated: true, completion: nil)
    }
}

extension LoginVC {
    private func handleSignIn(success: Bool) {
        // Log user in or yell at them for error
        guard success else {
            let alert = UIAlertController(title: "Oops",
                                          message: "Something went wrong when signing in.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
    }
}

extension SFSafariViewController {
   
    func playAudio() {
        
        var player: AVAudioPlayer?
        
        if let player = player, player.isPlaying {
            player.stop()
            print("player stopped")
        }
        
        else {
            let song = Bundle.main.path(forResource: "hello", ofType: "mp3")
            
            do {
                guard let song = song else {
                    return
                }
                
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: song))
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
                guard let player = player else {
                    return
                }
                
                player.play()
                print("player playing")
                
            } catch {
                print("did not play")
            }
        }
    }
}


