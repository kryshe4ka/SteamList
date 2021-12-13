//
//  AppDataSource.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation

class AppDataSource {
    static let shared = AppDataSource()
    
    var apps: [AppElement] = []
    
    func refreshData(apps: [AppElement]) {
        for app in apps {
            if app.name != "" {
                self.apps.append(app)
            }
        }
    }
}
