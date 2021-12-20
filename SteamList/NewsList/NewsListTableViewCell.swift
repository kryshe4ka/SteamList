//
//  NewsListTableViewCell.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 20.12.21.
//

import Foundation
import UIKit

struct NewsCellState {
    let appName: String
    let title: String
    let author: String
    let date: String
}

class NewsListTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: NewsListTableViewCell.self)

    let appNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = Font.regulareSystemFont
        nameLabel.textColor = Colors.content
        return nameLabel
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.boldSystemFont
        label.textColor = Colors.content
        label.allowsDefaultTighteningForTruncation = true
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = Font.regulareSystemFont
        label.textColor = Colors.content
        return label
    }()
    
    let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.font = Font.italicSystemFont
        authorLabel.textColor = Colors.content
        return authorLabel
    }()
    
    func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(appNameLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        addConstraints()
    }
    
    func update(state: NewsCellState) {
        appNameLabel.text = state.appName
        authorLabel.text = state.author
        titleLabel.text = state.title
        dateLabel.text = state.date
    }
    
    func addConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(20)
        }
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(appNameLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
}
