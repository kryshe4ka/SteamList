//
//  GamesListTableDelegate.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation
import UIKit

class GamesListTableViewDelegate: NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // перейти на экран с деталями игры
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.tableHeightForRow
    }
}

extension GamesListTableViewDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDataSource.shared.apps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GamesListTtableViewCell.reuseIdentifier, for: indexPath) as? GamesListTtableViewCell else {
            return UITableViewCell()
        }
        cell.index = indexPath.row
        cell.setupCell()
        if AppDataSource.shared.apps.isEmpty { return UITableViewCell() }
        let app = AppDataSource.shared.apps[indexPath.row]
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
