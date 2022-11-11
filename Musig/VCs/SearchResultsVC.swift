import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

class SearchResultsVC: UIViewController {
    
    private var sections: [SearchSection] = []
    
    var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView = UITableView(frame: .zero, style: .grouped)
        configureMyTableView()
        view.addSubview(myTableView)
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableViewConstraints()
    }
    
    func configureMyTableView() {
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.isHidden = true
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
        
        self.sections = [
            SearchSection(title: "Spotify", results: tracks),
        ]
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch result {
        case .spotify(let model):
            cell.textLabel?.text = "\(model.name) \(model.artists)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}
