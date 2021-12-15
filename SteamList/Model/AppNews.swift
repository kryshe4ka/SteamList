//
//  AppNews.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation

// MARK: - App
struct AppNews: Codable {
    let appnews: Appnews?
}

// MARK: - Appnews
struct Appnews: Codable {
    let appid: Int?
    let newsitems: [Newsitem]?
    let count: Int?
}

// MARK: - Newsitem
struct Newsitem: Codable {
    let gid, title: String?
    let url: String?
    let isExternalURL: Bool?
    let author: String?
    let contents: String?
    let feedlabel: String?
    let date: Int?
    let feedname: String?
    let feedType, appid: Int?
    let tags: [String]?

    enum CodingKeys: String, CodingKey {
        case gid, title, url
        case isExternalURL = "is_external_url"
        case author, contents, feedlabel, date, feedname
        case feedType = "feed_type"
        case appid, tags
    }
}
