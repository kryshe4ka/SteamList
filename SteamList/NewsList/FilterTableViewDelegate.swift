//
//  FilterTableViewDelegate.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 3.01.22.
//

import UIKit

class FilterTableViewDelegate: NSObject, UITableViewDelegate {
//    weak var controller: Delegate?
    weak var controller: NewsListViewController?

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.tableHeightForRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = controller else { return }
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = (cell.accessoryType == .checkmark) ? .none : .checkmark
            if cell.accessoryType == .none {
                /// remove from filtered list
                let appItem = controller.appDataSource.favApps[indexPath.row]
                controller.filteredFavApps.removeAll { app in
                    app.appid == appItem.appid
                }
            } else {
                /// add to filtered list
                let appItem = controller.appDataSource.favApps[indexPath.row]
                controller.filteredFavApps.append(appItem)
            }
        }
    }
}

extension FilterTableViewDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let controller = controller else { return 0 }
        return controller.appDataSource.favApps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.reuseIdentifier, for: indexPath) as? FilterTableViewCell else { return UITableViewCell() }
        cell.setupCell()
        guard let controller = controller else { return cell }
        if controller.appDataSource.favApps.isEmpty { return cell }
        let app = AppDataSource.shared.favApps[indexPath.row]
        cell.update(name: app.name)
        
        if controller.filteredFavApps.contains(where: { $0.appid == app.appid }) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}
