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
    private let newsShortDescriptionView = NewsShortDescriptionView()
    
    private func addConstraints() {
        newsShortDescriptionView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(newsShortDescriptionView)
        addConstraints()
    }
    
    func update(state: NewsCellState) {
        newsShortDescriptionView.update(state: state)
    }
}
