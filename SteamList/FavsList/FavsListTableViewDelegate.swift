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
            app = AppDataSource.shared.favApps[indexPath.row]
        }
        let appId = app.appid
        let appName = app.name
        let isFavorite = app.isFavorite!
        let gameDetailsViewController = GameDetailsViewController(appId: appId, appName: appName, isFavorite: isFavorite)
        controller.navigationController?.pushViewController(gameDetailsViewController, animated: true)
    }
}

extension FavsListTableViewDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let controller = controller else { return AppDataSource.shared.favApps.count}
        if controller.isFiltering {
            return controller.filteredTableData.count
          }
        return AppDataSource.shared.favApps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavsListTtableViewCell.reuseIdentifier, for: indexPath) as? FavsListTtableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell()
        let app: AppElement
        if let controller = controller, controller.isFiltering {
            if controller.filteredTableData.isEmpty { return cell }
            app = controller.filteredTableData[indexPath.row]
        } else {
            if AppDataSource.shared.favApps.isEmpty { return cell }
            app = AppDataSource.shared.favApps[indexPath.row]
        }
        let state = CellState(name: app.name, isFavorite: false)
        cell.update(state: state)
        return cell
    }
}
