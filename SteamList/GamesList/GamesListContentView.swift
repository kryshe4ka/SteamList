//
//  GamesListContentView.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation
import UIKit
import SnapKit

class GamesListContentView: UIView {
    
    let searchView = SearchView()
    var delegate = GamesListTableViewDelegate()

    private var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            Colors.gradientTop.cgColor,
            Colors.gradientBottom.cgColor
        ]
        gradient.locations = [0.5, 1];
        return gradient
    }()
    
    var gamesListTableView: TableView = {
        let table = TableView()
        table.register(GamesListTtableViewCell.self, forCellReuseIdentifier: GamesListTtableViewCell.reuseIdentifier)
        return table
    }()
    
    init() {
        super.init(frame: .zero)
        gamesListTableView.delegate = delegate
        gamesListTableView.dataSource = delegate
        addSubview(searchView)
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
    
    func addConstraints() {
        searchView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        gamesListTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
        }
    }
}
