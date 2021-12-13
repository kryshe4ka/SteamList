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
    
    let favoriteButton: UIButton = {
        let favoriteButton = UIButton(frame: .zero)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(Icons.favorites, for: .normal)
        favoriteButton.setImage(Icons.favoritesSelected, for: .highlighted)
        favoriteButton.setImage(Icons.favoritesSelected, for: .focused)
        return favoriteButton
    }()
    
    func setupCell() {
        backgroundColor = .clear
        contentView.addSubview(nameLabel)
        contentView.addSubview(favoriteButton)
        addConstraints()
    }
    
    func update(state: CellState) {
        nameLabel.text = state.name
    }
    
    func addConstraints() {
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        favoriteButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        favoriteButton.setContentCompressionResistancePriority(.init(rawValue: 1000.0), for: .horizontal)

        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Offset.offset * 2),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Offset.offset * 2),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30.0),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30.0),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -Offset.offset),
        ])
    }
}
