//
//  GameDetailsViewController.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 14.12.21.
//

import Foundation
import UIKit

class GameDetailsViewController: UIViewController {
    
    let contentView = UIView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.navBarBackground
        setUpNavigation()
        getAppDetails()
    }
    
    func setUpNavigation() {
        self.navigationItem.title = "Game"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.content]
    }
    
    func getAppDetails() {
        //
    }
}
