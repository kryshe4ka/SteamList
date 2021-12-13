//
//  App.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation

// MARK: - App
struct App: Decodable {
    let applist: Applist
}

// MARK: - Applist
struct Applist: Decodable {
    let apps: [AppElement]
}

// MARK: - AppElement
struct AppElement: Decodable {
    let appid: Int
    let name: String
    var isFavorite: Bool? = false
}
