//
//  StorageProtocol.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation

protocol Storage {
    func fetchApps() -> [App]
    func fetchAppDetails(appId: Int) -> AppDetails
    func fetchAppNews(appId: Int, count: Int) -> [AppNews]
}
