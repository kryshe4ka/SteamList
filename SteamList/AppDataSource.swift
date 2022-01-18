//
//  AppDataSource.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 13.12.21.
//

import Foundation

protocol DataSource {
    var apps: [AppElement] { get set }
    var favApps: [AppElement] { get }
    var news: [Newsitem] { get }
    var needUpdateFavList: Bool { get set }
    var needUpdateNewsList: Bool { get set }
    func refreshData(apps: [AppElement])
    func refreshData(appId: Int, appDetails: AppDetails)
    func refreshData(with news: [Newsitem], appId: Int)
    func toggleFavorite(index: Int, favoriteState: Bool)
}

class AppDataSource: DataSource {
    static let shared = AppDataSource()
    var apps: [AppElement] = []
    var needUpdateFavList = false
    var needUpdateNewsList = false
    var needUpdateGamesList = false
    var currentSortKey = "name"
    var favApps: [AppElement] = []
    var news: [Newsitem] {
        var newsArray: [Newsitem] = []
        favApps.forEach { 
            if let news = $0.news, !news.isEmpty {
                newsArray += news
            }
        }
        return newsArray
    }

    func updateFavAppsData() {
        self.favApps = CoreDataManager.shared.fetchFavoriteApps(sortKey: currentSortKey)
    }
    
    func refreshData(apps: [AppElement]) {
        self.apps.removeAll()
        updateFavAppsData() /// get favorites list from DB
        for app in apps {
            if app.name != "" {
                var newApp = app
                newApp.price = app.price
                newApp.haveDiscount = app.haveDiscount
                if favApps.contains(where: { favApp in
                    if favApp.appid == app.appid {
                        newApp.haveDiscount = favApp.haveDiscount
                        newApp.price = favApp.price
                    }
                    return favApp.appid == app.appid
                }) {
                    newApp.isFavorite = true
                } else {
                    // иначе false
                    newApp.isFavorite = false
                }
                self.apps.append(newApp)
            }
        }
    }
    
    func refreshData(appId: Int, appDetails: AppDetails) {
        if let index = apps.firstIndex(where: { $0.appid == appId }) {
            apps[index].appDetails = appDetails
            /// create price string:
            var price: String
            if let isFree = apps[index].appDetails?.isFree, isFree {
                price = "Free"
            } else {
                price = apps[index].appDetails?.priceOverview?.finalFormatted?.trimmingCharacters(in: CharacterSet(charactersIn: "USD ")) ?? "-"
            }
            var haveDiscount: Bool = false
            if let discount = apps[index].appDetails?.priceOverview?.discountPercent, discount != 0 {
                price += " (-\(discount)%)"
                haveDiscount = true
            }
            apps[index].haveDiscount = haveDiscount
            apps[index].price = price
            
            if let indexFav = favApps.firstIndex(where: { $0.appid == appId })  {
                favApps[indexFav].appDetails = appDetails
                favApps[indexFav].haveDiscount = haveDiscount
                favApps[indexFav].price = price
            }
        }
    }
    
    func toggleFavorite(index: Int, favoriteState: Bool) {
        apps[index].isFavorite = favoriteState
        needUpdateFavList = true
        needUpdateNewsList = true
        if favoriteState {
            CoreDataManager.shared.addAppToFavorites(app: apps[index])
            updateFavAppsData()
        } else {
            CoreDataManager.shared.removeAppFromFavorites(app: apps[index])
            updateFavAppsData()
        }
    }
    
    func refreshData(with news: [Newsitem], appId: Int) {
        if let index = apps.firstIndex(where: { $0.appid == appId }) {
            apps[index].news = news
        }
        if let index = favApps.firstIndex(where: { $0.appid == appId }) {
            favApps[index].news = news
        }
    }
}
