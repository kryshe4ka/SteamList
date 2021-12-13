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
        //
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
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
        cell.setupCell()
        if AppDataSource.shared.apps.isEmpty { return UITableViewCell() }
        let app = AppDataSource.shared.apps[indexPath.row]
        let state = CellState(name: app.name, isFavorite: false)
        cell.update(state: state)
        return cell
    }
}
