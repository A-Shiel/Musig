import UIKit

class SearchVC: UIViewController, UISearchBarDelegate {
    
    var myTableView: UITableView!
    let searchBar = UISearchController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSearchBar()
    }
    
    func configureSearchBar() {
        navigationItem.searchController = searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        self.searchBar.searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        
        SpotifyAPICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        print(query)
    }
}
