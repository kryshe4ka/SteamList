//
//  GamesListTtableViewCell.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation
import UIKit
import SnapKit

struct CellState {
    let name: String
    let isFavorite: Bool
}

final class GamesListTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: GamesListTableViewCell.self)
    
    var isFavorite: Bool = false
    var index = 0
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = Font.boldSystemFont
        nameLabel.textColor = Colors.content
        return nameLabel
    }()
    
    private let favoriteButton: UIButton = {
        let favoriteButton = UIButton(frame: .zero)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(Icons.favUnchecked, for: .normal)
        favoriteButton.setImage(Icons.favChecked, for: .highlighted)
        favoriteButton.imageView?.isUserInteractionEnabled = false
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return favoriteButton
    }()
    
    func setupCell() {
        selectionStyle = .none
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
    
    private func addConstraints() {
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        favoriteButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        favoriteButton.setContentCompressionResistancePriority(.init(rawValue: 1000.0), for: .horizontal)

        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-10)
        }
        let buttonSize: CGFloat = 30
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.height.width.equalTo(buttonSize)
            make.centerY.equalToSuperview()
        }
    }
}
