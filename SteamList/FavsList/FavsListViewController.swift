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
