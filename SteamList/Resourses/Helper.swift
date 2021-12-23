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
    static let tableHeightForRow = 50.0
    static let newsTableHeightForRow = 90.0
}
enum Colors {
    static let navBarBackground = UIColor(named: "navBarBackground")!
    static let tabBarBackground = UIColor(named: "tabBarBackground")!
    static let content = UIColor.white
    static let searchBackground = UIColor(named: "searchBackground")!
    static let searchContent = UIColor(named: "searchContent")!
    static let gradientTop = UIColor(named: "gradientTop")!
    static let gradientBottom = UIColor(named: "gradientBottom")!
    static let green = UIColor(named: "green")!
}

enum Font {
    static let boldSystemFont = UIFont.boldSystemFont(ofSize: 16)
    static let boldTitleFont = UIFont.boldSystemFont(ofSize: 24)
    static let regulareSystemFont = UIFont.systemFont(ofSize: 14)
    static let italicSystemFont = UIFont.italicSystemFont(ofSize: 14)
}

enum Offset {
    static let offset = 10.0
}

enum Icons {
    static let favUnchecked = UIImage(named: "star.empty")
    static let favChecked = UIImage(named: "star.fill")
}

extension String {
    var toDateFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        let date = Date(timeIntervalSinceReferenceDate: TimeInterval(Int(self) ?? 0))
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.000Z'"
        let printFormatter = DateFormatter()
        printFormatter.dateFormat = "d MMM, yyyy"
        printFormatter.locale = Locale(identifier: "en_US")
        return printFormatter.string(from: date)
    }
    
    var toEnDateFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMM. yyyy"
        guard let date = dateFormatter.date(from: self) else {return self}
        let printFormatter = DateFormatter()
        printFormatter.locale = Locale(identifier: "en_US")
        printFormatter.dateFormat = "d MMM, yyyy"
        return printFormatter.string(from: date)
    }
}

extension UISearchBar {
    func setPlaceholderTextColorTo(color: UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color
    }

    func setMagnifyingGlassColorTo(color: UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
    }
}
