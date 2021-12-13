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
    
    var gamesListTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(GamesListTtableViewCell.self, forCellReuseIdentifier: GamesListTtableViewCell.reuseIdentifier)
        table.backgroundColor = .clear
        return table
    }()
    var delegate = GamesListTableViewDelegate()
    
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
    
    let offset = 10.0
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            searchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            searchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset),
            
            gamesListTableView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            gamesListTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            gamesListTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset),
            gamesListTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
