//
//  StorageProtocol.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation

protocol Storage {
    func fetchAppDetails(appId: Int) -> AppDetails
    func fetchAppNews(appId: Int, count: Int) -> [Newsitem]
    func saveContext()
    
    func fetchApps(completion: @escaping (Result<[AppElement], Error>) -> Void)
//    func fetchAppDetails(appId: Int, completion: @escaping (Result<[AppDetails], Error>) -> Void)
}
