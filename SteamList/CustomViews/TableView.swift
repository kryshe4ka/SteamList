//
//  TableView.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation
import UIKit

class TableView: UITableView {
    
    lazy var refreshControlExtra: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Colors.content
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: Colors.content])
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    init() {
        super.init(frame: .zero, style: .plain)
        separatorColor = Colors.tabBarBackground
        backgroundColor = .clear
        refreshControlExtra.backgroundColor = Colors.gradientTop
        addSubview(refreshControlExtra)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func refresh() {
        reloadData()
        self.refreshControlExtra.endRefreshing()
    }
}
