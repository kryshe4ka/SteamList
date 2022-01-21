//
//  MockNotificationType.swift
//  SteamListTests
//
//  Created by Liza Kryshkovskaya on 21.01.22.
//

import Foundation
@testable import SteamList

class MockNotificationType: NotificationType {
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        
    }
    
    func fetchNotificationSettings() {
        
    }
    
    func scheduleNotification(task: Task) {
        
    }
    
    
}
