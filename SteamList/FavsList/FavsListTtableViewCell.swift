//
//  FavsListTtableViewCell.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation
import UIKit

struct FavCellState {
    let name: String
    let isFavorite: Bool
    let price: Float?
}

class FavsListTtableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: FavsListTtableViewCell.self)
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = Font.boldSystemFont
        nameLabel.textColor = Colors.content
        return nameLabel
    }()
    
    let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = Font.boldSystemFont
        priceLabel.textColor = Colors.content
        priceLabel.text = "$9.99"
        return priceLabel
    }()
    
    func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(nameLabel)
        addSubview(priceLabel)
        addConstraints()
    }
    
    func update(state: CellState) {
        nameLabel.text = state.name
    }
    
    func addConstraints() {
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        priceLabel.setContentCompressionResistancePriority(.init(rawValue: 1000.0), for: .horizontal)

        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Offset.offset * 2),
            
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Offset.offset * 2),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -Offset.offset),
        ])
    }
}
