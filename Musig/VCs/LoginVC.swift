import UIKit
import MusicKit
import SafariServices


class LoginVC: UIViewController, SFSafariViewControllerDelegate {
    
    var myTableView: UITableView!
    var list: [String] = ["Spotify", "Apple Music", "YouTube"]
    
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

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if (indexPath.row == 0) {
//            print("0")
//        }
//        if (indexPath.row == 1) {
//            print("1")
//        }
//        if (indexPath.row == 2) {
//            print("2")
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }
}

extension LoginVC: LoginCellDelegate {
    func didTapButton(with title: String) {
        if title == "Spotify" {
            let vc = SpotifyAuthVC()
            vc.completionHandler = { [weak self] success in
                DispatchQueue.main.async {
                    self?.handleSignIn(success: success)
                }
            }
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
//            spotifyAlertReturn()

            // call method to loop through device list and grab name key from device
            // if device.name == "iPhone"
            // grab the associated value with the key device.ID
            // store value into a variable
        }
        
        if title == "Apple Music" {
            Task {
             let status = await MusicAuthorization.request()
                switch status {
                case .authorized:
                    print("authorized")
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
        
        if title == "YouTube" {
            
        }
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
        
//        if success {
//           linkDeviceIDS()
//        }
    }
}


