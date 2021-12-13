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
    var favApps: [AppElement] = []
    var isFavoritesWasChanged: Bool = false
    
    func refreshData(apps: [AppElement]) {
        for app in apps {
            if app.name != "" {
                var newApp = app
                newApp.isFavorite = false
                self.apps.append(newApp)
            }
        }
    }
    
    func toggleFavorite(index: Int, favoriteState: Bool) {
        apps[index].isFavorite = favoriteState
        favoriteState ? addToFavList(app: apps[index]) : removeFromFavList(app: apps[index])
        isFavoritesWasChanged = true
    }
    
    func addToFavList(app: AppElement) {
        self.favApps.append(app)
    }
    
    func removeFromFavList(app: AppElement) {
        self.favApps.removeAll{ $0.appid == app.appid }
    }
}
