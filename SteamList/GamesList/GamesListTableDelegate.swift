//
//  GamesListTableDelegate.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation
import UIKit

final class GamesListTableViewDelegate: NSObject, UITableViewDelegate {
    weak var controller: GamesListViewController?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// display screen with app details
        guard let controller = controller else { return }
        let app: AppElement
        if controller.isFiltering {
            app = controller.filteredTableData[indexPath.row]
        } else {
            app = controller.appDataSource.apps[indexPath.row]
        }
        let gameDetailsViewController = GameDetailsViewController(app: app)
        gameDetailsViewController.delegate = controller
        controller.navigationController?.pushViewController(gameDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.tableHeightForRow
    }
}

extension GamesListTableViewDelegate: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let controller = controller else { return AppDataSource.shared.apps.count}
        if controller.isFiltering {
            return controller.filteredTableData.count
          }
        return controller.appDataSource.apps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GamesListTableViewCell.reuseIdentifier, for: indexPath) as? GamesListTableViewCell else {
            return UITableViewCell()
        }
        cell.index = indexPath.row
        cell.setupCell()
        guard let controller = controller else { return cell }
        let app: AppElement
        if controller.isFiltering {
            if controller.filteredTableData.isEmpty { return cell }
            app = controller.filteredTableData[indexPath.row]
            
        } else {
            if controller.appDataSource.apps.isEmpty { return cell }
            app = controller.appDataSource.apps[indexPath.row]
        }
        let state = CellState(name: app.name, isFavorite: app.isFavorite!)
        cell.update(state: state)
        return cell
    }
}
