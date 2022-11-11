import UIKit

class SearchVC: UIViewController, UISearchBarDelegate {
    
    var myTableView: UITableView!
    let searchController = UISearchController(searchResultsController: SearchResultsVC())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSearchBar()
    }
    
    func configureSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //guard let query = searchBar.text else { return }
        // fix searchController
        // 25:26 part 16 timestamp
        guard let resultsController = searchController.searchResultsController as? SearchResultsVC,
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        SpotifyAPICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    // implement
                    resultsController.update(with: results)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        print(query)
    }
}
