//
//  FavsListViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import UIKit

protocol Notifiable {
    func fetch(_ completion: () -> Void)
    func sendNotification(task: Task)
}

enum SortingKey: String {
    case name = "name"
    case price = "priceRawValue"
}

final class FavsListViewController: UIViewController, Delegate {
    private let group = DispatchGroup()
    private let contentView = FavsListContentView()
    private let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    var filteredTableData: [AppElement] = []
    
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
    
    override func loadView() {
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentView.favsListTableView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        /// Takes care of toggling the button's title.
        super.setEditing(editing, animated: true)
        /// Toggle table view editing.
        contentView.favsListTableView.setEditing(editing, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        configureSearchController()
        contentView.delegate.controller = self
    }
    
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
        /// appearence
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
            guard let self = self else { return }
            self.appDataSource.currentSortKey = SortingKey.name
            self.appDataSource.updateFavAppsData()
            self.contentView.favsListTableView.reloadData()
        }
        let priceAlertAction = UIAlertAction(title: "Sort by Price", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.appDataSource.currentSortKey = SortingKey.price
            self.appDataSource.updateFavAppsData()
            self.contentView.favsListTableView.reloadData()
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(titleAlertAction)
        alertController.addAction(priceAlertAction)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredTableData = self.appDataSource.favApps.filter { (app: AppElement) -> Bool in
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

extension FavsListViewController: Notifiable {
    func fetch(_ completion: () -> Void) {
        getAppDetails()
        completion()
    }
    
    func sendNotification(task: Task) {
        NotificationManager.shared.scheduleNotification(task: task)
    }
    
    private func getAppDetails() {
        let apps = self.appDataSource.favApps
        apps.forEach { app in
            group.enter()
            getAppDetails(app: app, group: group)
        }
        group.notify(queue: .main) {
            self.appDataSource.updateFavAppsData()
            self.updateTable()
        }
    }
    
    private func getAppDetails(app: AppElement, group: DispatchGroup) {
        let request = self.networkDataManager.buildRequestForFetchAppDetails(appId: app.appid)
        let completion: (Result<DecodedObject, Error>) -> Void = { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let object):
                    if object.decodedObject.success {
                        guard let detailsData = object.decodedObject.data else { return }
                        
                        let currentPrice = app.priceRawValue ?? 0.0
                        /// create price string:
                        var newPrice: Float
                        var priceString: String
                        if let isFree = detailsData.isFree, isFree {
                            newPrice = 0.0
                            priceString = "0"
                        } else {
                            priceString = detailsData.priceOverview?.finalFormatted?.trimmingCharacters(in: CharacterSet(charactersIn: "$USD ")) ?? "0"
                            newPrice = Float(priceString) ?? 0
                        }
                                                
                        if newPrice <= currentPrice {
                            let task = Task(id: UUID().uuidString, name: app.name, body: "The price has dropped to $\(priceString)!")
                            self.sendNotification(task: task)
                        }
                        
                        self.deleteAppDetailsFromStorage(appId: app.appid)
                        self.saveAppDetailsToStorage(appDetails: detailsData)
                        self.dataManager.updateFavoriteApp(app: app, appDetails: detailsData)
                        self.appDataSource.refreshData(appId: app.appid, appDetails: detailsData)
                        
                    } else {
                        print("Not success)")
                    }
                    group.leave()
                case .failure(_):
                    ErrorHandler.showErrorAlert(with: "Failed to update data from internet. Please try again later...", presenter: self)
                    group.leave()
            }
        }
        /// perform request on another queue
        DispatchQueue.global(qos: .background).async {
            self.networkDataManager.get(request: request, completion: completion)
        }
    }

    private func saveAppDetailsToStorage(appDetails: AppDetails) {
        self.dataManager.saveAppDetails(appDetails) { result in
            switch result {
            case .failure(_):
                ErrorHandler.showErrorAlert(with: "Failed to save data to local storage", presenter: self)
            case .success(_):
                print("SaveAppDetailsToStorage: success")
            }
        }
    }
    
    private func deleteAppDetailsFromStorage(appId: Int) {
        self.dataManager.deleteAppDetails(appId: appId) { result in
            switch result {
            case .failure(_):
                ErrorHandler.showErrorAlert(with: "Failed to delete data from local storage", presenter: self)
            case .success(_):
                print("DeleteAppDetailsFromStorage: success")
            }
        }
    }
}
