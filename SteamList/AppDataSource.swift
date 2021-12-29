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
    
    var favApps: [AppElement] = []
    
//    var favApps: [AppElement] {
////        return apps.filter { $0.isFavorite! }
//        return CoreDataManager.shared.fetchFavoriteApps()
//    }
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
        self.favApps = CoreDataManager.shared.fetchFavoriteApps()
    }
    
    func refreshData(apps: [AppElement]) {
        // получить список фаваритов из БД
        updateFavAppsData()
        
        for app in apps {
            if app.name != "" {
                var newApp = app
                newApp.price = app.price
                newApp.haveDiscount = app.haveDiscount
                // если newApp.id есть в списке, то isFavorite = true
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
            var app = apps[index]
            app.appDetails = appDetails
            apps[index].appDetails = appDetails
            /// create price string:
            var price: String
            if let isFree = app.appDetails?.isFree, isFree {
                price = "Free"
            } else {
                price = app.appDetails?.priceOverview?.finalFormatted?.trimmingCharacters(in: CharacterSet(charactersIn: "USD ")) ?? "-"
            }
            var haveDiscount: Bool = false
            if let discount = app.appDetails?.priceOverview?.discountPercent, discount != 0 {
                price += " (-\(discount)%)"
                haveDiscount = true
            }
            app.haveDiscount = haveDiscount
            app.price = price
        }
    }
    
    func refreshFavoriteData(favApps: [AppElement]) {
        
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
    }
}
