//
//  AppDelegate.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var tabBarController: UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([gamesListNavigationController, favsListNavigationController, newsListNavigationController], animated: false)
        tabBarController.tabBar.backgroundColor = Colors.tabBarBackground
        return tabBarController
    }
    
    var gamesListNavigationController: UINavigationController {
        let gamesListViewController = GamesListViewController()
        let navigationController = UINavigationController(rootViewController: gamesListViewController)
        navigationController.tabBarItem.image = UIImage(named: TabBarImage.games)
        navigationController.tabBarItem.selectedImage = UIImage(named: TabBarImage.games)
        navigationController.tabBarItem.title = TabBar.games
        return navigationController
    }
    
    var favsListNavigationController: UINavigationController {
        let favsListViewController = FavsListViewController()
        let navigationController = UINavigationController(rootViewController: favsListViewController)
        navigationController.tabBarItem.image = UIImage(named: TabBarImage.favorites)
        navigationController.tabBarItem.selectedImage = UIImage(named: TabBarImage.favorites)
        navigationController.tabBarItem.title = TabBar.favorites
        return navigationController
    }
    
    var newsListNavigationController: UINavigationController {
        let newsListViewController = NewsListViewController()
        let navigationController = UINavigationController(rootViewController: newsListViewController)
        navigationController.tabBarItem.image = UIImage(named: TabBarImage.news)
        navigationController.tabBarItem.selectedImage = UIImage(named: TabBarImage.news)
        navigationController.tabBarItem.title = TabBar.news
        return navigationController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}
