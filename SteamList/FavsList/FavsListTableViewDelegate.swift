//
//  FavsListTableViewDelegate.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation
import UIKit

final class FavsListTableViewDelegate: NSObject, UITableViewDelegate {
    var controller: FavsListViewController?

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.tableHeightForRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// display screen with app details
        guard let controller = controller else { return }
        let app: AppElement
        if controller.isFiltering {
            app = controller.filteredTableData[indexPath.row]
        } else {
            app = controller.appDataSource.favApps[indexPath.row]
        }
        let gameDetailsViewController = GameDetailsViewController(app: app) // еще можно передать детали
        gameDetailsViewController.delegate = controller
        controller.navigationController?.pushViewController(gameDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let controller = controller else { return }
        if editingStyle == .delete {
            /// Delete the row from the data source
            let app = controller.appDataSource.favApps[indexPath.row]
            controller.dataManager.removeAppFromFavorites(app: app)
            controller.appDataSource.favApps.remove(at: indexPath.row)
            if let index = controller.appDataSource.apps.firstIndex(where: { $0.appid == app.appid }) {
                controller.appDataSource.apps[index].isFavorite = false
            }
            controller.appDataSource.needUpdateGamesList = true
            /// Delete the row from the TableView
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension FavsListTableViewDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let controller = controller else { return AppDataSource.shared.favApps.count}
        if controller.isFiltering {
            return controller.filteredTableData.count
          }
        return controller.appDataSource.favApps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavsListTtableViewCell.reuseIdentifier, for: indexPath) as? FavsListTtableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell()
        let app: AppElement
        guard let controller = controller else { return cell}
        if controller.isFiltering {
            if controller.filteredTableData.isEmpty { return cell }
            app = controller.filteredTableData[indexPath.row]
        } else {
            if controller.appDataSource.favApps.isEmpty { return cell }
            app = controller.appDataSource.favApps[indexPath.row]
        }
        let price = app.price ?? "-"
        let haveDiscount = app.haveDiscount ?? false
        cell.update(name: app.name, price: price, haveDiscount: haveDiscount)
        return cell
    }
}
