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
    var needUpdateFavList = false
    var needUpdateNewsList = false
    var news1: [Newsitem] = []
    
    var favApps: [AppElement] {
        return apps.filter { $0.isFavorite! }
    }
    var news: [Newsitem] {
        var newsArray: [Newsitem] = []
        favApps.forEach { 
            if let news = $0.news, !news.isEmpty {
                newsArray += news
            }
        }
        return newsArray
    }
    
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
        needUpdateFavList = true
        needUpdateNewsList = true
    }
    
    func refreshData(appId: Int, appDetails: AppDetails) {
        if let index = apps.firstIndex(where: { $0.appid == appId }) {
            apps[index].appDetails = appDetails
        }
    }
    
    func updateNews(with news: [Newsitem], appId: Int) {
        if let index = apps.firstIndex(where: { $0.appid == appId }) {
            apps[index].news = news
        }
    }
}
