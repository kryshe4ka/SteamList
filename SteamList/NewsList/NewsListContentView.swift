//
//  NewsListContentView.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 15.12.21.
//

import Foundation
import UIKit
import SnapKit

class NewsListContentView: UIView {
    let delegate = NewsListTableViewDelegate()
    
    private var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            Colors.gradientTop.cgColor,
            Colors.gradientBottom.cgColor
        ]
        gradient.locations = [0.5, 1];
        return gradient
    }()
    
    var newsListTableView: TableView = {
        let table = TableView()
        table.register(NewsListTableViewCell.self, forCellReuseIdentifier: NewsListTableViewCell.reuseIdentifier)
        return table
    }()
    
    init() {
        super.init(frame: .zero)
        layer.insertSublayer(self.gradientLayer, at: 0)
        newsListTableView.delegate = delegate
        newsListTableView.dataSource = delegate
        addSubview(newsListTableView)
        addConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        newsListTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
