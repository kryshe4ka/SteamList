//
//  FilterTableViewDelegate.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 3.01.22.
//

import UIKit

class FilterTableViewDelegate: NSObject, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.tableHeightForRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = (cell.accessoryType == .checkmark) ? .none : .checkmark
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
        cell.accessoryType = .checkmark
        return cell
    }
}
