//
//  App.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation

// MARK: - App
struct App: Codable, Equatable {
    static func == (lhs: App, rhs: App) -> Bool {
        lhs.applist.apps == rhs.applist.apps
    }
    
    let applist: Applist
}

// MARK: - Applist
struct Applist: Codable {
    let apps: [AppElement]
}

// MARK: - AppElement
struct AppElement: Codable, Equatable {
    static func == (lhs: AppElement, rhs: AppElement) -> Bool {
        lhs.appid == rhs.appid
    }
    
    let appid: Int
    let name: String
    var isFavorite: Bool? = false
    var appDetails: AppDetails?
    var news: [Newsitem]?
    var price: String?
    var haveDiscount: Bool?
}
