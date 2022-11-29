import UIKit

// this is where we left off
// implement tableview
// save data within an array in playlist

struct PlaylistArray: Codable {
    static var array = [SearchResult]()
}

class PlaylistVC: UIViewController {
    
    var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView = UITableView()
        configureMyTableView()
        view.addSubview(myTableView)
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableViewContraints()
        view.backgroundColor = .systemBackground

    }
    
    // reloads data everytime "playlist" is tapped
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myTableView.reloadData()
    }
    
    func configureMyTableView() {
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorColor = .clear
    }
    
    // move to struct or class reusable
    func myTableViewContraints() {
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        myTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension PlaylistVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaylistArray.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let result = PlaylistArray.
        let result = PlaylistArray.array[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch result {
        case .spotify(let model):
            cell.textLabel?.text = "\(model.name) - \(model.artists[0].name)"
        case .apple(let model):
            cell.textLabel?.text = "\(model.title) - \(model.artistName)"
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            PlaylistArray.array.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
            
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = PlayerVC()
        
        vc.hidesBottomBarWhenPushed = true
        PlayerVC.shared.initialIndex = indexPath.row
        PlayerVC.shared.jumpOffPlayer()
        navigationController?.pushViewControllerFromTop(controller: vc)
        navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let result = PlaylistArray.array[indexPath.row]
//
//        let vc = PlayerVC()
//
//        vc.hidesBottomBarWhenPushed = true
//
//        switch result {
//
//        // IF SPOTIFY SONG
//
//        case .spotify(let model):
//            //            PlayerPresenter.startPlayback(from: self, spotify: spotify)
//            //            navigationController?.show(vc, sender: spotify)
//            navigationController?.pushViewControllerFromTop(controller: vc)
//            navigationController?.setNavigationBarHidden(true, animated: false)
////            vc.stopApplePlayback()
//            vc.stopApplePlayback()
//            vc.startPlayback(spotify: model)
//
//        // IF APPLE SONG
//
//        case .apple(let model):
//            //            PlayerPresenter.startPlayback(from: self, apple: apple)
//            //            navigationController?.show(vc, sender: apple)
//            //            navigationController?.pushViewController(vc, animated: true)
//            navigationController?.pushViewControllerFromTop(controller: vc)
//            navigationController?.setNavigationBarHidden(true, animated: false)
//            vc.startPlayback(apple: model)
//            SpotifyAPICaller.shared.pausePlayback() { response in
//                DispatchQueue.main.async {
//                    switch response {
//                    case .success(let r):
//                        vc.startPlayback(apple: model)
//                        print(r)
//                        print("SUCCESS")
//                    default:
//                        print("ERROR 101")
//                    }
//                }
//            }
//        }
//    }
}
