//
//  FilterTableViewCell.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 3.01.22.
//

import Foundation
import UIKit

class FilterTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: FilterTableViewCell.self)
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = Font.regulareSystemFont
        nameLabel.textColor = Colors.content
        return nameLabel
    }()
    
    func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(nameLabel)
        addConstraints()
    }
    
    func update(name: String) {
        nameLabel.text = name
    }
    
    private func addConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(22)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
