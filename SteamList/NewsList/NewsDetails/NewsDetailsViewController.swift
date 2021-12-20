//
//  NewsDetailsViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 20.12.21.
//

import Foundation
import UIKit

class NewsDetailsViewController: UIViewController {
    let contentView = NewsDetailsContentView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = .red
    }
    
}
