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

    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        setUpNavigation()
        contentView.delegate.controller = self
        getAppsFromStorage()
        getApps()
    }
    
    func getAppsFromStorage() {
        CoreDataManager.shared.fetchApps { result in
            switch result {
            case .success(let apps):
                print(apps.count)
                AppDataSource.shared.refreshData(apps: apps)
                self.updateTable()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
        searchController.searchBar.searchBarStyle = .minimal
        contentView.gamesListTableView.tableHeaderView = searchController.searchBar
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
            guard let self = self else {return}
            // обновляем UI на главной очереди
            DispatchQueue.main.async {
                switch result {
                case .success(let app):
                    /// update data source and reload table
                    AppDataSource.shared.refreshData(apps: app.applist.apps)
                    self.updateTable()
                    CoreDataManager.shared.deleteApps { result in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success(_):
                            print("Success deleting")
                        }
                    }
                    CoreDataManager.shared.saveApps(app.applist.apps) { result in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success(_):
                            print("Success saving")
                        }
                    }
                    // спрятать индикатор загрузки
                    // тут -> ...
                case .failure(let error):
                    // спрятать индикатор загрузки
                    // тут -> ...
                    // повторить попытку загрузки, текущее значение попытки увеличить
                    // если кол-во попыток исчерпано, то отобразить error alert
                    // тут -> ...
                    print(error)
                }
            }
        }
        // отобразить индикатор загрузки
        // тут -> ...
        
        // выполняем запрос на др.очереди
        DispatchQueue.global(qos: .utility).async {
            NetworkDataManager.shared.get(request: request, completion: completion)
        }
    }
    
    private func updateTable() {
        contentView.gamesListTableView.reloadData()
    }
}


extension GamesListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
      let searchBar = searchController.searchBar
      filterContentForSearchText(searchBar.text!)
  }
}
