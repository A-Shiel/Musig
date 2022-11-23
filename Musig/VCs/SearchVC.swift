import UIKit
import MusicKit

class SearchVC: UIViewController, UISearchBarDelegate {
    
    var myTableView: UITableView!
    let searchController = UISearchController(searchResultsController: SearchResultsVC())
    var array: [SearchResult] = []
    
    // felt cute, might delete later
    var deviceArray: [DeviceResult] = []
    
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
   
    // clears the search bar when cancel is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let resultsController = searchController.searchResultsController as? SearchResultsVC
        self.array = []
        resultsController?.update(with: self.array)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let resultsController = searchController.searchResultsController as? SearchResultsVC,
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        self.array = []
        self.deviceArray = []
        
//        Task {
//            SpotifyAPICaller.shared.getDeviceIDS(completion:) { result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let results):
//                        self.deviceArray.append(contentsOf: results)
//                        print("1111")
//                        break
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//        }
//
        Task {
            SpotifyAPICaller.shared.search(with: query) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let results):
                        //                    resultsController.update(with: results)
                        self.array.append(contentsOf: results)
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            await AMCaller.shared.search(with: query) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let results):
                        //                        resultsController.update(with: results)
                        self.array.append(contentsOf: results)
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            resultsController.update(with: self.array)
        }
    }
}
