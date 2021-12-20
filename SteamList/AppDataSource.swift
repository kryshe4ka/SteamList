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
    var news: [Newsitem] = []
    
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
        // !!! удалить и все сопутствующие новости удаляемой игры
    }
    
    func refreshData(appId: Int, appDetails: AppDetails) {
        print("refreshData for appId = \(appId), index?")
    }
    
    func updateNews(with news: [Newsitem]) {
        // добавить проверку на пустоту
        self.news.append(contentsOf: news)
    }
    
    func setChangesDone() {
        isFavoritesWasChanged = false
    }
}
