//
//  NewsShortDescriptionView.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 21.12.21.
//

import Foundation
import UIKit

class NewsShortDescriptionView: UIView {
        
    private let appNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = Font.smallSystemFont
        nameLabel.textColor = Colors.content
        nameLabel.text = "-"
        return nameLabel
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.boldSystemFont
        label.textColor = Colors.content
        label.allowsDefaultTighteningForTruncation = true
        label.text = "-"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Font.smallSystemFont
        label.textColor = Colors.content
        return label
    }()
    
    private let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.font = Font.italicSystemFont
        authorLabel.textColor = Colors.content
        return authorLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        addConstraints()
    }
    
    private func commonInit() {
        addSubview(appNameLabel)
        addSubview(authorLabel)
        addSubview(titleLabel)
        addSubview(dateLabel)
    }
    
    private func addConstraints() {
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
    
    func update(state: NewsCellState) {
        appNameLabel.text = state.appName
        authorLabel.text = state.author
        titleLabel.text = state.title
        dateLabel.text = state.date
    }
}
