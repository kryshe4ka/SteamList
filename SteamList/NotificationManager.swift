//
//  NotificationManager.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 18.01.22.
//

import Foundation
import UserNotifications
import CoreLocation

protocol NotificationType {
    func requestAuthorization(completion: @escaping  (Bool) -> Void)
    func fetchNotificationSettings()
    func scheduleNotification(task: Task)
}

enum NotificationManagerConstants {
  static let timeBasedNotificationThreadId =
    "TimeBasedNotificationThreadId"
}

struct Task {
    var id = UUID().uuidString
    var name: String
    var body: String
}

class NotificationManager: NotificationType {
    static let shared = NotificationManager()
    var settings: UNNotificationSettings?

    func requestAuthorization(completion: @escaping  (Bool) -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
                self.fetchNotificationSettings()
                completion(granted)
            }
    }
    
    func fetchNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.settings = settings
            }
        }
    }
    
    func scheduleNotification(task: Task) {
        let content = UNMutableNotificationContent()
        content.title = task.name
        content.body = task.body
        content.threadIdentifier = NotificationManagerConstants.timeBasedNotificationThreadId
        
        var trigger: UNNotificationTrigger?
        let timeInterval: TimeInterval = TimeInterval(3) // 3 sec
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        if let trigger = trigger {
            let request = UNNotificationRequest(identifier: task.id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
}
