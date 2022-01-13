//
//  FilterTableViewDelegate.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 3.01.22.
//

import UIKit

class FilterTableViewDelegate: NSObject, UITableViewDelegate {
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
                let appItem = AppDataSource.shared.favApps[indexPath.row]
                controller.filteredFavApps.removeAll { app in
                    app.appid == appItem.appid
                }
            } else {
                /// add to filtered list
                let appItem = AppDataSource.shared.favApps[indexPath.row]
                controller.filteredFavApps.append(appItem)
            }
        }
    }
}

extension FilterTableViewDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDataSource.shared.favApps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.reuseIdentifier, for: indexPath) as? FilterTableViewCell else { return UITableViewCell() }
        cell.setupCell()
        if AppDataSource.shared.favApps.isEmpty { return cell }
        let app = AppDataSource.shared.favApps[indexPath.row]
        cell.update(name: app.name)
        
        guard let controller = controller else { return cell }
        if controller.filteredFavApps.contains(where: { $0.appid == app.appid }) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}
