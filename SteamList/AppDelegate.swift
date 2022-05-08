import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        configureAppearance()
        configureUserNotifications()
        
        let window = UIWindow()
        self.window = window
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
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
}

// MARK: - UNUserNotificationCenterDelegate
// Viewing Notification When the App Is in the Foreground
extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .sound, .badge])
    }
}
