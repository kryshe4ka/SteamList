//
//  Helper.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import UIKit

enum TabBar {
    static let games: String = "Games"
    static let favorites: String = "Favs"
    static let news: String = "News"
}

enum TabBarImage {
    static let games: String = "list"
    static let favorites: String = "star.fill"
    static let news: String = "book"
}

enum Constants {
    static let gamesTabTitle = "Games"
    static let favsTabTitle = "Favorites"
    static let newsTabTitle = "News"
}
enum Colors {
    static let navBarBackground = UIColor(named: "navBarBackground")
    static let tabBarBackground = UIColor(named: "tabBarBackground")
    static let content = UIColor.white
    static let searchBackground = UIColor(named: "searchBackground")
    static let searchContent = UIColor(named: "searchContent")


}

enum Font {
    static let boldSystemFont = UIFont.boldSystemFont(ofSize: 16)
}

enum Offset {
    static let offset = 10.0
}

enum Icons {
    static let favorites = UIImage(named: "star.empty")
    static let favoritesSelected = UIImage(named: "star.fill")

}
