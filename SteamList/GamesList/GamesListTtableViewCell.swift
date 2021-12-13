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
    
    var isFavorite: Bool = false
    var index = 0
    
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
        favoriteButton.setImage(Icons.favUnchecked, for: .normal)
        favoriteButton.setImage(Icons.favChecked, for: .highlighted)
        favoriteButton.imageView?.isUserInteractionEnabled = false
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
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
        isFavorite = state.isFavorite
        setFavoriteButtonState()
    }
    
    @objc func toggleFavorite(sender: UIButton) {
        isFavorite = !isFavorite
        setFavoriteButtonState()
        /// save favorite state in the data source
        AppDataSource.shared.toggleFavorite(index: index, favoriteState: isFavorite)
    }
    
    func setFavoriteButtonState() {
        isFavorite ? favoriteButton.setImage(Icons.favChecked, for: .normal) : favoriteButton.setImage(Icons.favUnchecked, for: .normal)
        isFavorite ? favoriteButton.setImage(Icons.favUnchecked, for: .highlighted) : favoriteButton.setImage(Icons.favChecked, for: .highlighted)
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
