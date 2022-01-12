//
//  FavsListTtableViewCell.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import SnapKit
import UIKit

final class FavsListTtableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: FavsListTtableViewCell.self)
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = Font.boldSystemFont
        nameLabel.textColor = Colors.content
        return nameLabel
    }()
    
    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = Font.boldSystemFont
        priceLabel.textColor = Colors.content
        return priceLabel
    }()
    
    func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(nameLabel)
        addSubview(priceLabel)
        addConstraints()
    }
    
    func update(name: String, price: String, haveDiscount: Bool) {
        nameLabel.text = name
        priceLabel.text = price
        priceLabel.textColor = haveDiscount ? Colors.green : Colors.content
    }
    
    private func addConstraints() {
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        priceLabel.setContentCompressionResistancePriority(.init(rawValue: 1000.0), for: .horizontal)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(priceLabel.snp.leading).offset(-10)
        }
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
}
