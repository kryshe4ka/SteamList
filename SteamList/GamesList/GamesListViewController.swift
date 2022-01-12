//
//  GamesListViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import UIKit

final class GamesListViewController: UIViewController {
    private let contentView = GamesListContentView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    var filteredTableData: [AppElement] = []
    var needUpdateFavorites: Bool = false
    
    override func loadView() {
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needUpdateFavorites {
            updateTable()
            needUpdateFavorites = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        setUpNavigation()
        contentView.delegate.controller = self
        getAppsFromStorage()
        getApps()
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
        searchController.searchBar.searchBarStyle = .minimal
        contentView.gamesListTableView.tableHeaderView = searchController.searchBar
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        /// configure searchBar appearence
        searchController.searchBar.tintColor = Colors.content
        searchController.searchBar.barTintColor = Colors.gradientTop
        searchController.searchBar.backgroundColor = Colors.gradientTop
        searchController.searchBar.setPlaceholderTextColorTo(color: Colors.content)
        searchController.searchBar.setMagnifyingGlassColorTo(color: Colors.searchContent)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredTableData = AppDataSource.shared.apps.filter { (app: AppElement) -> Bool in
            return app.name.lowercased().contains(searchText.lowercased())
        }
        contentView.gamesListTableView.reloadData()
    }
    
    private func setUpNavigation() {
        self.navigationItem.title = Constants.gamesTabTitle
        /// customize back bar button
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    private func getApps() {
        let request = NetworkDataManager.shared.buildRequestForFetchApps()
        let completion: (Result<App, Error>) -> Void = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let app):
                self.deleteAppsFromStorage()
                self.saveAppsToStorage(apps: app.applist.apps)
                self.updateDataAndUI(apps: app.applist.apps)
            case .failure(let error):
                print(error)
            }
        }
        DispatchQueue.global(qos: .utility).async {
            NetworkDataManager.shared.get(request: request, completion: completion)
        }
    }
    
    private func updateTable() {
        contentView.gamesListTableView.reloadData()
    }
    
    private func getAppsFromStorage() {
        CoreDataManager.shared.fetchApps { result in
            switch result {
            case .success(let apps):
                self.updateDataSource(apps: apps)
                self.updateTable()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func deleteAppsFromStorage() {
        CoreDataManager.shared.deleteApps { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(_):
                print("Success deleting")
            }
        }
    }
    
    private func saveAppsToStorage(apps: [AppElement]) {
        CoreDataManager.shared.saveApps(apps) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(_):
                print("Success saving")
            }
        }
    }
    
    private func updateDataAndUI(apps: [AppElement]) {
        self.updateDataSource(apps: apps)
        DispatchQueue.main.async {
            self.updateTable()
        }
    }
    
    private func updateDataSource(apps: [AppElement]) {
        AppDataSource.shared.refreshData(apps: apps)
    }
}

extension GamesListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
      let searchBar = searchController.searchBar
      filterContentForSearchText(searchBar.text!)
  }
}
