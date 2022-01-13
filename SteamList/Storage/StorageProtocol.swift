//
//  StorageProtocol.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation

protocol Storage {
    func fetchApps(completion: @escaping (Result<[AppElement], Error>) -> Void)
    func saveApps(_ apps: [AppElement], completion: @escaping (Result<Bool, Error>) -> Void)
    func deleteApps(completion: @escaping (Result<Bool, Error>) -> Void)

    
//    func fetchAppDetails(appId: Int) -> AppDetails
//    func fetchAppNews(appId: Int, count: Int, completion: @escaping (Result<[Newsitem], Error>) -> Void) 
   
    func fetchAppDetails(appId: Int, completion: @escaping (Result<AppDetails?, Error>) -> Void)
    
    
//    func fetchNews(app: AppElement) -> [Newsitem]
    
    func fetchAppNews(app: AppElement, count: Int, completion: @escaping (Result<[Newsitem], Error>) -> Void)

}
