//
//  AppDelegate.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import UIKit
import CoreData
import Firebase

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
        let gamesListViewController = GamesListViewController(networkDataManager: NetworkDataManager.shared, dataManager: CoreDataManager.shared, appDataSource: AppDataSource.shared)
        let navigationController = UINavigationController(rootViewController: gamesListViewController)
        navigationController.tabBarItem.image = UIImage(named: TabBarImage.games)
        navigationController.tabBarItem.selectedImage = UIImage(named: TabBarImage.games)
        navigationController.tabBarItem.title = TabBar.games
        return navigationController
    }
    
    var favsListNavigationController: UINavigationController {
        let favsListViewController = FavsListViewController(networkDataManager: NetworkDataManager.shared, dataManager: CoreDataManager.shared, appDataSource: AppDataSource.shared)
        let navigationController = UINavigationController(rootViewController: favsListViewController)
        navigationController.tabBarItem.image = UIImage(named: TabBarImage.favorites)
        navigationController.tabBarItem.selectedImage = UIImage(named: TabBarImage.favorites)
        navigationController.tabBarItem.title = TabBar.favorites
        return navigationController
    }
    
    var newsListNavigationController: UINavigationController {
        let newsListViewController = NewsListViewController(networkDataManager: NetworkDataManager.shared, dataManager: CoreDataManager.shared, appDataSource: AppDataSource.shared)
        let navigationController = UINavigationController(rootViewController: newsListViewController)
        navigationController.tabBarItem.image = UIImage(named: TabBarImage.news)
        navigationController.tabBarItem.selectedImage = UIImage(named: TabBarImage.news)
        navigationController.tabBarItem.title = TabBar.news
        return navigationController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        configureAppearance()
        configureUserNotifications()
        let window = UIWindow()
        window.backgroundColor = Colors.navBarBackground
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
    
    private func configureAppearance() {
        /// UINavigationBar Appearance
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = Colors.navBarBackground
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.content]
        UINavigationBar.appearance().tintColor = Colors.content
    }
    
    private func configureUserNotifications() {
        UNUserNotificationCenter.current().delegate = self /// add delegate method for viewing Notification When the App Is in the Foreground
        NotificationManager.shared.requestAuthorization { granted in
          if granted {
              print("Notifications are allowed")
          }
        }
    }
    
    // Support for background fetch
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        for viewController in favsListNavigationController.viewControllers {
            if let fetchViewController = viewController as? FavsListViewController {
                fetchViewController.fetch {
                    completionHandler(UIBackgroundFetchResult.newData)
                }
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
// Viewing Notification When the App Is in the Foreground
extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .sound, .badge])
    }
}
