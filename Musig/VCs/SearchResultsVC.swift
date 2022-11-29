import UIKit

struct SearchSection {
    let title: String
    // **************************************
    let results: [SearchResult]
}

class SearchResultsVC: UIViewController {
    
    // **************************************
    private var sections: [SearchSection] = []
    
    var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView = UITableView(frame: .zero, style: .grouped)
        configureMyTableView()
        view.addSubview(myTableView)
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableViewConstraints()
        view.backgroundColor = .systemBackground
    }
    
    func configureMyTableView() {
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.isHidden = true
        myTableView.separatorColor = .clear
    }
    
    func myTableViewConstraints() {
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        myTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func update(with results: [SearchResult]) {
        let tracks = results.filter({
            switch $0 {
            case .spotify: return true
            default: return false
            }
        })
        
        let songs = results.filter({
            switch $0 {
            case .apple: return true
            default: return false
            }
        })
        
//        let spotifySection = SearchSection(title: "Spotify", results: tracks)
//
//        if SearchVC.shared.appleMusicCanSearch {
//            let appleMusicSection = SearchSection(title: "Apple Music", results: songs)
//            self.sections = [spotifySection, appleMusicSection]
//        } else {
//            self.sections = [spotifySection]
//        }
        
        self.sections = [SearchSection(title: "Spotify", results: tracks), SearchSection(title: "Apple Music", results: songs)]
        
        myTableView.reloadData()
        myTableView.isHidden = results.isEmpty
    }
}

extension SearchResultsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    // [Musig.Artist(id: "hgoahierag04eaiohgosahrogarghroaing, name: ...)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = sections[indexPath.section].results[indexPath.row]
        let title = "Add to Playlist"
        
        switch result {
            
        case .spotify(let model):
            let alert = UIAlertController(title: title, message: "Do you want to add \"\(model.name) - \(model.artists[0].name)\" to your playlist?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler:  { action in
                
                // append to playlist array
                PlaylistArray.array.append(result)
                print(PlaylistArray.array.count)
                print(model.id)
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        case .apple(let model):
            
            let alert = UIAlertController(title: title, message: "Do you want to add \"\(model.title) - \(model.artistName)\" to your playlist?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler:  { action in
                
                // append to playlist array
                PlaylistArray.array.append(result)
                print(PlaylistArray.array.count)
                print(model.url!)
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}
