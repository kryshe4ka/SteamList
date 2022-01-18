//
//  FavsListViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import UIKit

final class FavsListViewController: UIViewController {
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
            AppDataSource.shared.currentSortKey = "name"
            AppDataSource.shared.updateFavAppsData()
            self!.contentView.favsListTableView.reloadData()
        }
        let priceAlertAction = UIAlertAction(title: "Sort by Price", style: .default) { [weak self] _ in
            AppDataSource.shared.currentSortKey = "price"
            AppDataSource.shared.updateFavAppsData()
            self!.contentView.favsListTableView.reloadData()
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
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

extension FavsListViewController {
    func fetch(_ completion: () -> Void) {
        print("background fetch")
        getAppDetails()
//        sendNotification()
        completion()
    }
    
//    func updateUI() {
//        print("updateUI или можно что-то еще сделать в комплишине")
//    }
    
    private func sendNotification(task: Task) {
        NotificationManager.shared.scheduleNotification(task: task)
        print("sendNotification")
    }
    

    private func getAppDetails() {
        let apps = AppDataSource.shared.favApps
        apps.forEach { app in
            group.enter()
            getAppDetails(app: app, group: group)
        }
        group.notify(queue: .main) {
            AppDataSource.shared.updateFavAppsData()
            self.updateTable()
        }
    }
    
    private func getAppDetails(app: AppElement, group: DispatchGroup) {
        print("getAppDetails")
        let request = NetworkDataManager.shared.buildRequestForFetchAppDetails(appId: app.appid)
        
        let completion: (Result<DecodedObject, Error>) -> Void = { [weak self] result in
            guard let self = self else { return }
//            DispatchQueue.main.async {
                switch result {
                case .success(let object):
                    if object.decodedObject.success {
                        guard let detailsData = object.decodedObject.data else { return }
                        
                        // сравнить новую цену с текущей
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
                                                
                        // если цена ниже, то отправить уведомление
                        if newPrice <= currentPrice {
                            let task = Task(id: UUID().uuidString, name: app.name, body: "The price has dropped to $\(priceString)!")
                            self.sendNotification(task: task)
                        }
                        
                        // сохранить данные в хранилище
                        self.deleteAppDetailsFromStorage(appId: app.appid)
                        self.saveAppDetailsToStorage(appDetails: detailsData)
                        CoreDataManager.shared.updateFavoriteApp(app: app, appDetails: detailsData)
        
                        AppDataSource.shared.refreshData(appId: app.appid, appDetails: detailsData)
                    } else {
                        print("Not success)")
                    }
                    group.leave()
                case .failure(_):
                    ErrorHandler.showErrorAlert(with: "Failed to update data from internet. Please try again later...", presenter: self)
                    group.leave()
                }
//            }
        }
        /// perform request on another queue
        DispatchQueue.global(qos: .background).async {
            NetworkDataManager.shared.get(request: request, completion: completion)
        }
    }
    
//    private func updateContentViewWith(appDetails: AppDetails) {
//        let price = appDetails.priceOverview?.finalFormatted ?? "Unknown"
//        print(price)
//    }

    private func saveAppDetailsToStorage(appDetails: AppDetails) {
        CoreDataManager.shared.saveAppDetails(appDetails) { result in
            switch result {
            case .failure(_):
                ErrorHandler.showErrorAlert(with: "Failed to save data to local storage", presenter: self)
            case .success(_):
                print("SaveAppDetailsToStorage: success")
            }
        }
    }
    
    private func deleteAppDetailsFromStorage(appId: Int) {
        CoreDataManager.shared.deleteAppDetails(appId: appId) { result in
            switch result {
            case .failure(_):
                ErrorHandler.showErrorAlert(with: "Failed to delete data from local storage", presenter: self)
            case .success(_):
                print("DeleteAppDetailsFromStorage: success")
            }
        }
    }
}
