//
//  GamesListContentView.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation
import UIKit

class GamesListContentView: UIView {
    
    let searchView = SearchView()
    var delegate = GamesListTableViewDelegate()

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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Offset.offset),
            searchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Offset.offset),
            gamesListTableView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            gamesListTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gamesListTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gamesListTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
