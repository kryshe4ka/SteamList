//
//  StorageProtocol.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation

protocol Storage {
    // apps
    func fetchApps(completion: @escaping (Result<[AppElement], Error>) -> Void)
    func saveApps(_ apps: [AppElement], completion: @escaping (Result<Bool, Error>) -> Void)
    func deleteApps(completion: @escaping (Result<Bool, Error>) -> Void)
    //app details
    func fetchAppDetails(appId: Int, completion: @escaping (Result<AppDetails?, Error>) -> Void)
    func saveAppDetails(_ appDetails: AppDetails, completion: @escaping (Result<Bool, Error>) -> Void)
    func deleteAppDetails(appId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    // news
    func fetchNews(completion: @escaping (Result<[Newsitem], Error>) -> Void)
    func saveNews(_ news: [Newsitem], completion: @escaping (Result<Bool, Error>) -> Void)
    func deleteNews(completion: @escaping (Result<Bool, Error>) -> Void)
    // favorites
    func fetchFavoriteApps(sortKey: String) -> [AppElement]
    func removeAppFromFavorites(app: AppElement)
    func addAppToFavorites(app: AppElement)
}
