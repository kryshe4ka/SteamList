//
//  FavsListTableViewDelegate.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation
import UIKit

class FavsListTableViewDelegate: NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.tableHeightForRow
    }
}

extension FavsListTableViewDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AppDataSource.shared.favApps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavsListTtableViewCell.reuseIdentifier, for: indexPath) as? FavsListTtableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell()
        if AppDataSource.shared.favApps.isEmpty { return UITableViewCell() }
        let app = AppDataSource.shared.favApps[indexPath.row]
        let state = CellState(name: app.name, isFavorite: false)
        cell.update(state: state)
        return cell
    }
    
    
}
