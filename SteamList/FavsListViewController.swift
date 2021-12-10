//
//  FavsListViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import UIKit

class FavsListViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.navBarBackground
        setUpNavigation()
    }
    
    func setUpNavigation() {
        self.navigationItem.title = Constants.favsTabTitle
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.content]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem?.tintColor = Colors.content
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = Colors.content
    }
}
