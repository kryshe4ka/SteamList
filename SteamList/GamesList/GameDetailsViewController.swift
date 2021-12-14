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
    let appId: Int
    let appName: String
    var isFavorite: Bool
    
    init(appId: Int, appName: String, isFavorite: Bool) {
        self.appId = appId
        self.appName = appName
        self.isFavorite = isFavorite
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        self.navigationItem.title = appName
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.content]
    }
    
    func getAppDetails() {
        print("appId = \(appId)")
    }
}
