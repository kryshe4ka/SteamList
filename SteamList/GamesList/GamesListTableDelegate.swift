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
            app = AppDataSource.shared.apps[indexPath.row]
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
        return AppDataSource.shared.apps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GamesListTableViewCell.reuseIdentifier, for: indexPath) as? GamesListTableViewCell else {
            return UITableViewCell()
        }
        cell.index = indexPath.row
        cell.setupCell()
        let app: AppElement
        if let controller = controller, controller.isFiltering {
            if controller.filteredTableData.isEmpty { return cell }
            app = controller.filteredTableData[indexPath.row]
            
        } else {
            if AppDataSource.shared.apps.isEmpty { return cell }
            app = AppDataSource.shared.apps[indexPath.row]
        }
        let state = CellState(name: app.name, isFavorite: app.isFavorite!)
        cell.update(state: state)
        
//        // если игра в любимых, то установить картинку полной звезды
//        if AppDataSource.shared.favApps содержит ячейку с id ячейки то  {
//            cell.addTOFVrtBtn.setImage("-", forState: UIControlState.Normal)
//        } else {
//            cell.addTOFVrtBtn.setImage("+", forState: UIControlState.Normal)
//        }
        
        return cell
    }
}
