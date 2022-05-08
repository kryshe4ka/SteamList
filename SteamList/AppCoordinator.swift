import UIKit

class AppCoordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        let gamesListViewController = GamesListViewController(networkDataManager: NetworkDataManager.shared, dataManager: CoreDataManager.shared, appDataSource: AppDataSource.shared)
        let gamesListNavigationController = createNavController(rootVC: gamesListViewController, tabBarItem: TabBarImage.games, title: TabBar.games)
        
        let favsListViewController = FavsListViewController(networkDataManager: NetworkDataManager.shared, dataManager: CoreDataManager.shared, appDataSource: AppDataSource.shared)
        let favsListNavigationController = createNavController(rootVC: favsListViewController, tabBarItem: TabBarImage.favorites, title: TabBar.favorites)
        
        let newsListViewController = NewsListViewController(networkDataManager: NetworkDataManager.shared, dataManager: CoreDataManager.shared, appDataSource: AppDataSource.shared)
        let newsListNavigationController = createNavController(rootVC: newsListViewController, tabBarItem: TabBarImage.news, title: TabBar.news)
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([gamesListNavigationController, favsListNavigationController, newsListNavigationController], animated: false)
        tabBarController.tabBar.backgroundColor = Colors.tabBarBackground
        
        window.rootViewController = tabBarController
        window.backgroundColor = Colors.navBarBackground
        window.makeKeyAndVisible()
    }
    
    private func createNavController(rootVC: UIViewController, tabBarItem: String, title: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.tabBarItem.image = UIImage(named: TabBarImage.news)
        navigationController.tabBarItem.selectedImage =  UIImage(named: TabBarImage.news)
        navigationController.tabBarItem.title = title
        return navigationController
    }
}
