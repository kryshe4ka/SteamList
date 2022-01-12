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
        let gameDetailsViewController = GameDetailsViewController(app: app) // еще можно передать детали
        controller.navigationController?.pushViewController(gameDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            /// Delete the row from the data source
            CoreDataManager.shared.removeAppFromFavorites(app: AppDataSource.shared.favApps[indexPath.row])
            AppDataSource.shared.favApps.remove(at: indexPath.row)
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
        let price = app.price ?? "-"
        let haveDiscount = app.haveDiscount ?? false
//        var price: String
//        if let isFree = app.appDetails?.isFree, isFree {
//            price = "Free"
//        } else {
//            price = app.appDetails?.priceOverview?.finalFormatted?.trimmingCharacters(in: CharacterSet(charactersIn: "USD ")) ?? "-"
//        }
//        var haveDiscount = false
//        if let discount = app.appDetails?.priceOverview?.discountPercent, discount != 0 {
//            price += " (-\(discount)%)"
//            haveDiscount = true
//        }
        
        cell.update(name: app.name, price: price, haveDiscount: haveDiscount)
        return cell
    }
}
