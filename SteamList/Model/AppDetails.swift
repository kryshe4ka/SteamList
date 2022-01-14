//
//  AppDetails.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation

// MARK: - DecodedObject
struct DecodedObject: Codable {
    var decodedObject: DataClass
    
    // Define DynamicCodingKeys type needed for creating decoding container from JSONDecoder
    private struct DynamicCodingKeys: CodingKey {
        // Use for string-keyed dictionary
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        // Use for integer-keyed dictionary
        var intValue: Int?
        init?(intValue: Int) {
            // We are not using this, thus just return nil
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        // Create a decoding container using DynamicCodingKeys
        // The container will contain all the JSON first level key
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        decodedObject = try container.decode(DataClass.self, forKey: DynamicCodingKeys(stringValue: container.allKeys.first!.stringValue)!)
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let success: Bool
    let data: AppDetails?
}

// MARK: - DataClass
struct AppDetails: Codable, Equatable {
    static func == (lhs: AppDetails, rhs: AppDetails) -> Bool {
        lhs.steamAppid == rhs.steamAppid
    }
    
    let name: String?
    let steamAppid: Int?
    let isFree: Bool?
    let shortDescription: String?
    let headerImage: String?
    let priceOverview: PriceOverview?
    let platforms: Platforms?
    let genres: [Genre]?
    let screenshots: [Screenshot]?
    let releaseDate: ReleaseDate?

    enum CodingKeys: String, CodingKey {
        case name
        case steamAppid = "steam_appid"
        case isFree = "is_free"
        case shortDescription = "short_description"
        case headerImage = "header_image"
        case priceOverview = "price_overview"
        case platforms
        case genres, screenshots
        case releaseDate = "release_date"
    }
}

// MARK: - Genre
struct Genre: Codable {
    let genreDescription: String?

    enum CodingKeys: String, CodingKey {
        case genreDescription = "description"
    }
}

// MARK: - Platforms
struct Platforms: Codable {
    let windows, mac, linux: Bool?
}

// MARK: - PriceOverview
struct PriceOverview: Codable {
    let currency: String?
    let initial, priceOverviewFinal, discountPercent: Int?
    let initialFormatted, finalFormatted: String?

    enum CodingKeys: String, CodingKey {
        case currency, initial
        case priceOverviewFinal = "final"
        case discountPercent = "discount_percent"
        case initialFormatted = "initial_formatted"
        case finalFormatted = "final_formatted"
    }
}

// MARK: - ReleaseDate
struct ReleaseDate: Codable {
    let date: String?

    enum CodingKeys: String, CodingKey {
        case date
    }
}

// MARK: - Screenshot
struct Screenshot: Codable {
    let pathFull: String?

    enum CodingKeys: String, CodingKey {
        case pathFull = "path_full"
    }
}
