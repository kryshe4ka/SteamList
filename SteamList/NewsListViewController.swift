//
//  NewsListViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import UIKit

class NewsListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.navBarBackground
        setUpNavigation()
    }
    
    func setUpNavigation() {
        self.navigationItem.title = Constants.newsTabTitle
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.content]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = Colors.content
    }
}
