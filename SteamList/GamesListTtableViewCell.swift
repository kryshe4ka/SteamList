//
//  GamesListTtableViewCell.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation
import UIKit

struct CellState {
    let name: String
    let isFavorite: Bool
}

class GamesListTtableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: GamesListTtableViewCell.self)
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = Font.boldSystemFont
        nameLabel.textColor = Colors.content
        return nameLabel
    }()
    
    func setupCell() {
        backgroundColor = .clear
        contentView.addSubview(nameLabel)
        addConstraints()
    }
    
    func update(state: CellState) {
        nameLabel.text = state.name
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
    }
}
