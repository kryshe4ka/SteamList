//
//  GamesListContentView.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation
import UIKit
import SnapKit

final class GamesListContentView: UIView {
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            Colors.gradientTop.cgColor,
            Colors.gradientBottom.cgColor
        ]
        gradient.locations = [0.5, 1];
        return gradient
    }()
    
    let gamesListTableView: TableView = {
        let table = TableView()
        table.register(GamesListTableViewCell.self, forCellReuseIdentifier: GamesListTableViewCell.reuseIdentifier)
        table.backgroundColor = .clear
        return table
    }()
    
//    lazy var topView: UIView = {
//        let topView = UIView()
//        topView.backgroundColor = .clear
//        return topView
//    }()
    
    let delegate = GamesListTableViewDelegate()
    
    init() {
        super.init(frame: .zero)
        gamesListTableView.delegate = delegate
        gamesListTableView.dataSource = delegate
//        addSubview(topView)
        addSubview(gamesListTableView)
        addConstraints()
        layer.insertSublayer(self.gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        gamesListTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
    }
}
