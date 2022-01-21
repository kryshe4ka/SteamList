//
//  CoreDataServiceStub.swift
//  SteamListTests
//
//  Created by Liza Kryshkovskaya on 20.01.22.
//

import Foundation
@testable import SteamList

class CoreDataManagerStub: Storage {

    var favApps = [
        AppElement(appid: 1, name: "C Test Game", isFavorite: true, price: "$2.0", priceRawValue: 2),
        AppElement(appid: 2, name: "A Test Game", isFavorite: true, price: "$3.0", priceRawValue: 3),
        AppElement(appid: 3, name: "B Test Game", isFavorite: true, price: "$1.0", priceRawValue: 1)
    ]

    func fetchApps(completion: @escaping (Result<[AppElement], Error>) -> Void) {
        completion(.success(MockedData.app.applist.apps))
    }
    
    func saveApps(_ apps: [AppElement], completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(true))
    }
    
    func deleteApps(completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(true))
    }
    
    func fetchAppDetails(appId: Int, completion: @escaping (Result<AppDetails?, Error>) -> Void) {
        completion(.success(MockedData.appDetails))
    }
    
    func saveAppDetails(_ appDetails: AppDetails, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(true))
    }
    
    func deleteAppDetails(appId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(true))
    }
    
    func fetchNews(completion: @escaping (Result<[Newsitem], Error>) -> Void) {
        completion(.success((MockedData.appNews.appnews?.newsitems)!))
    }
    
    func saveNews(_ news: [Newsitem], completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(true))
    }
    
    func deleteNews(completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(true))
    }

    func fetchFavoriteApps(sortKey: SortingKey) -> [AppElement] {
        var sortedResult: [AppElement] = []
        
        switch sortKey {
        case .name:
            sortedResult = favApps.sorted { leftApp, rightApp in
                leftApp.name < rightApp.name
            }
            return sortedResult
        case .price:
            sortedResult = favApps.sorted { leftApp, rightApp in
                leftApp.priceRawValue! < rightApp.priceRawValue!
            }
            return sortedResult
        }
    }
    
    func removeAppFromFavorites(app: AppElement) {
        favApps.removeAll { $0.appid == app.appid }
    }
    
    func addAppToFavorites(app: AppElement) {
        favApps.append(app)
    }
    
    func updateFavoriteApp(app: AppElement, appDetails: AppDetails) {
        var newApp = app
        newApp.appDetails = appDetails
        removeAppFromFavorites(app: app)
        addAppToFavorites(app: newApp)
    }
}
