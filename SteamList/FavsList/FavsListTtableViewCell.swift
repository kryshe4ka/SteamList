//
//  FavsListTtableViewCell.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation
import UIKit

struct FavCellState {
    let name: String
    let isFavorite: Bool
    let price: Float?
}

class FavsListTtableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: FavsListTtableViewCell.self)
    
    func setupCell() {
        
    }
    
    func update(state: CellState) {
        
    }
}
