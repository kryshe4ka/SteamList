//
//  AppNews.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation

// MARK: - App
struct AppNews: Codable, Equatable {
    static func == (lhs: AppNews, rhs: AppNews) -> Bool {
        lhs.appnews?.appid == rhs.appnews?.appid &&
        lhs.appnews?.newsitems == rhs.appnews?.newsitems &&
        lhs.appnews?.count == rhs.appnews?.count
    }
    
    let appnews: Appnews?
}

// MARK: - Appnews
struct Appnews: Codable {
    let appid: Int?
    let newsitems: [Newsitem]?
    let count: Int?
}

// MARK: - Newsitem
struct Newsitem: Codable, Equatable {
    let gid, title: String?
    let author: String?
    let contents: String?
    let date: Int?
    let appid: Int?
}
