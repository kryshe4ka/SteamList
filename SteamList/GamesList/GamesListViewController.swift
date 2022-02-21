//
//  GamesListViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import UIKit

final class GamesListViewController: UIViewController, Delegate {
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
    
    let networkDataManager: NetworkDataManager
    let dataManager: CoreDataManager
    let appDataSource: AppDataSource
    
    init(networkDataManager: NetworkDataManager, dataManager: CoreDataManager, appDataSource: AppDataSource) {
        self.networkDataManager = networkDataManager
        self.dataManager = dataManager
        self.appDataSource = appDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needUpdateFavorites {
            updateTable()
            needUpdateFavorites = false
        }
        if self.appDataSource.needUpdateGamesList {
            updateTable()
            self.appDataSource.needUpdateGamesList = false
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
        filteredTableData = self.appDataSource.apps.filter { (app: AppElement) -> Bool in
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
        let request = self.networkDataManager.buildRequestForFetchApps()
        let completion: (Result<App, Error>) -> Void = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let app):
                self.deleteAppsFromStorage()
                self.saveAppsToStorage(apps: app.applist.apps)
                self.updateDataAndUI(apps: app.applist.apps)
            case .failure(_):
                ErrorHandler.showErrorAlert(with: "Failed to update data from internet. Please try again later...", presenter: self)
            }
        }
        DispatchQueue.global(qos: .utility).async {
            self.networkDataManager.get(request: request, completion: completion)
        }
    }
    
    private func updateTable() {
        contentView.gamesListTableView.reloadData()
    }
    
    private func getAppsFromStorage() {
        self.dataManager.fetchApps { result in
            switch result {
            case .success(let apps):
                self.updateDataSource(apps: apps)
                self.updateTable()
            case .failure(_):
                ErrorHandler.showErrorAlert(with: "Failed to update data from local storage. Please try again later...", presenter: self)
            }
        }
    }
    
    private func deleteAppsFromStorage() {
        self.dataManager.deleteApps { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(_):
                print("Success deleting")
            }
        }
    }
    
    private func saveAppsToStorage(apps: [AppElement]) {
        self.dataManager.saveApps(apps) { result in
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
        self.appDataSource.refreshData(apps: apps)
    }
}

extension GamesListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
      let searchBar = searchController.searchBar
      filterContentForSearchText(searchBar.text!)
  }
}
