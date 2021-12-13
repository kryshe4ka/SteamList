//
//  TableView.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation
import UIKit

class TableView: UITableView {
    
    init() {
        super.init(frame: .zero, style: .plain)
        separatorColor = Colors.tabBarBackground
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
