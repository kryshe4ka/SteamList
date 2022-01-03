//
//  FavsListViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import UIKit

final class FavsListViewController: UIViewController {
    private let contentView = FavsListContentView()
    private let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    var filteredTableData: [AppElement] = []
    
    override func loadView() {
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.favsListTableView.reloadData()
        
//        if AppDataSource.shared.needUpdateFavList {
//            AppDataSource.shared.needUpdateFavList = false
//            
////            AppDataSource.shared.favApps.forEach { app in
////                if app.appDetails == nil {
////                    getAppDetails(app: app)
////                }
////            }
//            contentView.favsListTableView.reloadData()
//        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        print("setEditing")
        
        // Takes care of toggling the button's title.
        super.setEditing(editing, animated: true)

        // Toggle table view editing.
        contentView.favsListTableView.setEditing(editing, animated: true)
    }
    
    private func getAppDetails(app: AppElement) {
        let request = NetworkDataManager.shared.buildRequestForFetchAppDetails(appId: app.appid)
        let completion: (Result<DecodedObject, Error>) -> Void = { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let object):
                    if object.decodedObject.success {
                        guard let detailsData = object.decodedObject.data else { return }
                        AppDataSource.shared.refreshData(appId: app.appid, appDetails: detailsData)
                        self.contentView.favsListTableView.reloadData()
                    } else {
                        print("Bad success = \(object.decodedObject.success)")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        /// perform request on another queue
        DispatchQueue.global(qos: .utility).async {
            NetworkDataManager.shared.get(request: request, completion: completion)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        AppDataSource.shared.updateFavAppsData()
        
        setUpNavigation()
        configureSearchController()
        contentView.delegate.controller = self
        
//        getFavoriteApps()
    }
    
//    private func getFavoriteApps() {
//        CoreDataManager.shared.fetchFavoriteApps { result in
//            switch result {
//            case .failure(let error):
//                print(error)
//            case .success(let favApps):
//                print(favApps.count)
//                AppDataSource.shared.refreshFavoriteData(favApps: favApps)
//                self.updateTable()
//                print("UI обновился From Storage")
//            }
//        }
//    }
    
    private func updateTable() {
        contentView.favsListTableView.reloadData()
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
        searchController.searchBar.searchBarStyle = .minimal
        contentView.favsListTableView.tableHeaderView = searchController.searchBar
        // appearence
        searchController.searchBar.tintColor = Colors.content
        searchController.searchBar.barTintColor = Colors.gradientTop
        searchController.searchBar.backgroundColor = Colors.gradientTop
        searchController.searchBar.setPlaceholderTextColorTo(color: Colors.content)
        searchController.searchBar.setMagnifyingGlassColorTo(color: Colors.searchContent)
    }
    
    private func setUpNavigation() {
        self.navigationItem.title = Constants.favsTabTitle
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(self.showSortOptions(_:)))
        self.navigationItem.rightBarButtonItem = editButtonItem
        /// customize back bar button
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    @objc func showSortOptions(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Choose your option", message: nil, preferredStyle: .actionSheet)
        let titleAlertAction = UIAlertAction(title: "Sort by Title", style: .default) { [weak self] _ in
            print("Sort by Title")
            AppDataSource.shared.currentSortKey = "name"
            AppDataSource.shared.updateFavAppsData()
            self!.contentView.favsListTableView.reloadData()
        }
        let priceAlertAction = UIAlertAction(title: "Sort by Price", style: .default) { [weak self] _ in
            print("Sort by Price")
            AppDataSource.shared.currentSortKey = "price"
            AppDataSource.shared.updateFavAppsData()
            self!.contentView.favsListTableView.reloadData()
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        /// set text color
//        alertController.view.tintColor = Colors.gradientBottom
//        cancelAlertAction.setValue(UIColor(red: 0.922, green: 0.341, blue: 0.341, alpha: 1), forKey: "titleTextColor")
        alertController.addAction(titleAlertAction)
        alertController.addAction(priceAlertAction)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredTableData = AppDataSource.shared.favApps.filter { (app: AppElement) -> Bool in
            return app.name.lowercased().contains(searchText.lowercased())
        }
        contentView.favsListTableView.reloadData()
    }
}

extension FavsListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
      let searchBar = searchController.searchBar
      filterContentForSearchText(searchBar.text!)
  }
}
