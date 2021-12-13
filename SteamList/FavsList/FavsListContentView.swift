//
//  FavsListContentView.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation
import UIKit

class FavsListContentView: UIView {
    
    let searchView = SearchView()
    var delegate = FavsListTableViewDelegate()

    
    let favsListTableView: TableView = {
        let table = TableView()
        table.register(FavsListTtableViewCell.self, forCellReuseIdentifier: FavsListTtableViewCell.reuseIdentifier)
        return table
    }()
    
    init() {
        super.init(frame: .zero)
        favsListTableView.delegate = delegate
        favsListTableView.dataSource = delegate
        addSubview(searchView)
        addSubview(favsListTableView)
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
            favsListTableView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            favsListTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            favsListTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            favsListTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
