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
struct AppDetails: Codable {
//    let type: String?
    let name: String?
    let steamAppid: Int?
//    let requiredAge: Int?
    let isFree: Bool?
//    let detailedDescription, aboutTheGame, supportedLanguages: String?
    let shortDescription: String?
    let headerImage: String?
//    let website: String?
//    let pcRequirements: [JSONAny]?
//    let macRequirements, linuxRequirements: [JSONAny]?
//    let legalNotice: String?
//    let developers, publishers: [String]?
    let priceOverview: PriceOverview?
//    let packages: [Int]?
//    let packageGroups: [PackageGroup]?
    let platforms: Platforms?
//    let categories: [Category]?
    let genres: [Genre]?
    let screenshots: [Screenshot]?
//    let movies: [Movie]?
//    let achievements: Achievements?
    let releaseDate: ReleaseDate?
//    let supportInfo: SupportInfo?
//    let background: String?
//    let contentDescriptors: ContentDescriptors?

    enum CodingKeys: String, CodingKey {
//        case type
        case name
        case steamAppid = "steam_appid"
//        case requiredAge = "required_age"
        case isFree = "is_free"
//        case detailedDescription = "detailed_description"
//        case aboutTheGame = "about_the_game"
        case shortDescription = "short_description"
//        case supportedLanguages = "supported_languages"
        case headerImage = "header_image"
//        case website
//        case pcRequirements = "pc_requirements"
//        case macRequirements = "mac_requirements"
//        case linuxRequirements = "linux_requirements"
//        case legalNotice = "legal_notice"
//        case developers, publishers
        case priceOverview = "price_overview"
//        case packages
//        case packageGroups = "package_groups"
        case platforms
//        case categories
        case genres, screenshots
//        case movies, achievements
        case releaseDate = "release_date"
//        case supportInfo = "support_info"
//        case background
//        case contentDescriptors = "content_descriptors"
    }
}

//// MARK: - Achievements
//struct Achievements: Codable {
//    let total: Int?
//    let highlighted: [Highlighted]?
//}
//
//// MARK: - Highlighted
//struct Highlighted: Codable {
//    let name: String?
//    let path: String?
//}

//// MARK: - Category
//struct Category: Codable {
//    let id: Int?
//    let categoryDescription: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case categoryDescription = "description"
//    }
//}

//// MARK: - ContentDescriptors
//struct ContentDescriptors: Codable {
//    let ids: [JSONAny]?
//    let notes: JSONNull?
//}

// MARK: - Genre
struct Genre: Codable {
    let id, genreDescription: String?

    enum CodingKeys: String, CodingKey {
        case id
        case genreDescription = "description"
    }
}

//// MARK: - Movie
//struct Movie: Codable {
//    let id: Int?
//    let name: String?
//    let thumbnail: String?
//    let webm, mp4: Mp4?
//    let highlight: Bool?
//}

//// MARK: - Mp4
//struct Mp4: Codable {
//    let the480, max: String?
//
//    enum CodingKeys: String, CodingKey {
//        case the480 = "480"
//        case max
//    }
//}
//
//// MARK: - PackageGroup
//struct PackageGroup: Codable {
//    let name, title, packageGroupDescription, selectionText: String?
//    let saveText: String?
//    let displayType: Int?
//    let isRecurringSubscription: String?
//    let subs: [Sub]?
//
//    enum CodingKeys: String, CodingKey {
//        case name, title
//        case packageGroupDescription = "description"
//        case selectionText = "selection_text"
//        case saveText = "save_text"
//        case displayType = "display_type"
//        case isRecurringSubscription = "is_recurring_subscription"
//        case subs
//    }
//}

//// MARK: - Sub
//struct Sub: Codable {
//    let packageid: Int?
//    let percentSavingsText: String?
//    let percentSavings: Int?
//    let optionText, optionDescription, canGetFreeLicense: String?
//    let isFreeLicense: Bool?
//    let priceInCentsWithDiscount: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case packageid
//        case percentSavingsText = "percent_savings_text"
//        case percentSavings = "percent_savings"
//        case optionText = "option_text"
//        case optionDescription = "option_description"
//        case canGetFreeLicense = "can_get_free_license"
//        case isFreeLicense = "is_free_license"
//        case priceInCentsWithDiscount = "price_in_cents_with_discount"
//    }
//}

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
    let comingSoon: Bool?
    let date: String?

    enum CodingKeys: String, CodingKey {
        case comingSoon = "coming_soon"
        case date
    }
}

// MARK: - Screenshot
struct Screenshot: Codable {
    let id: Int?
    let pathThumbnail, pathFull: String?

    enum CodingKeys: String, CodingKey {
        case id
        case pathThumbnail = "path_thumbnail"
        case pathFull = "path_full"
    }
}

//// MARK: - SupportInfo
//struct SupportInfo: Codable {
//    let url: String?
//    let email: String?
//}

//// MARK: - Encode/decode helpers
//
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(0)
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}

//class JSONCodingKey: CodingKey {
//    let key: String
//
//    required init?(intValue: Int) {
//        return nil
//    }
//
//    required init?(stringValue: String) {
//        key = stringValue
//    }
//
//    var intValue: Int? {
//        return nil
//    }
//
//    var stringValue: String {
//        return key
//    }
//}
//
//class JSONAny: Codable {
//
//    let value: Any
//
//    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
//        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
//        return DecodingError.typeMismatch(JSONAny.self, context)
//    }
//
//    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
//        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
//        return EncodingError.invalidValue(value, context)
//    }
//
//    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
//        if let value = try? container.decode(Bool.self) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self) {
//            return value
//        }
//        if let value = try? container.decode(Double.self) {
//            return value
//        }
//        if let value = try? container.decode(String.self) {
//            return value
//        }
//        if container.decodeNil() {
//            return JSONNull()
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
//        if let value = try? container.decode(Bool.self) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self) {
//            return value
//        }
//        if let value = try? container.decode(Double.self) {
//            return value
//        }
//        if let value = try? container.decode(String.self) {
//            return value
//        }
//        if let value = try? container.decodeNil() {
//            if value {
//                return JSONNull()
//            }
//        }
//        if var container = try? container.nestedUnkeyedContainer() {
//            return try decodeArray(from: &container)
//        }
//        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
//            return try decodeDictionary(from: &container)
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
//        if let value = try? container.decode(Bool.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(Double.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(String.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decodeNil(forKey: key) {
//            if value {
//                return JSONNull()
//            }
//        }
//        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
//            return try decodeArray(from: &container)
//        }
//        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
//            return try decodeDictionary(from: &container)
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
//        var arr: [Any] = []
//        while !container.isAtEnd {
//            let value = try decode(from: &container)
//            arr.append(value)
//        }
//        return arr
//    }
//
//    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
//        var dict = [String: Any]()
//        for key in container.allKeys {
//            let value = try decode(from: &container, forKey: key)
//            dict[key.stringValue] = value
//        }
//        return dict
//    }
//
//    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
//        for value in array {
//            if let value = value as? Bool {
//                try container.encode(value)
//            } else if let value = value as? Int64 {
//                try container.encode(value)
//            } else if let value = value as? Double {
//                try container.encode(value)
//            } else if let value = value as? String {
//                try container.encode(value)
//            } else if value is JSONNull {
//                try container.encodeNil()
//            } else if let value = value as? [Any] {
//                var container = container.nestedUnkeyedContainer()
//                try encode(to: &container, array: value)
//            } else if let value = value as? [String: Any] {
//                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
//                try encode(to: &container, dictionary: value)
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//    }
//
//    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
//        for (key, value) in dictionary {
//            let key = JSONCodingKey(stringValue: key)!
//            if let value = value as? Bool {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? Int64 {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? Double {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? String {
//                try container.encode(value, forKey: key)
//            } else if value is JSONNull {
//                try container.encodeNil(forKey: key)
//            } else if let value = value as? [Any] {
//                var container = container.nestedUnkeyedContainer(forKey: key)
//                try encode(to: &container, array: value)
//            } else if let value = value as? [String: Any] {
//                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
//                try encode(to: &container, dictionary: value)
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//    }
//
//    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
//        if let value = value as? Bool {
//            try container.encode(value)
//        } else if let value = value as? Int64 {
//            try container.encode(value)
//        } else if let value = value as? Double {
//            try container.encode(value)
//        } else if let value = value as? String {
//            try container.encode(value)
//        } else if value is JSONNull {
//            try container.encodeNil()
//        } else {
//            throw encodingError(forValue: value, codingPath: container.codingPath)
//        }
//    }
//
//    public required init(from decoder: Decoder) throws {
//        if var arrayContainer = try? decoder.unkeyedContainer() {
//            self.value = try JSONAny.decodeArray(from: &arrayContainer)
//        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
//            self.value = try JSONAny.decodeDictionary(from: &container)
//        } else {
//            let container = try decoder.singleValueContainer()
//            self.value = try JSONAny.decode(from: container)
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        if let arr = self.value as? [Any] {
//            var container = encoder.unkeyedContainer()
//            try JSONAny.encode(to: &container, array: arr)
//        } else if let dict = self.value as? [String: Any] {
//            var container = encoder.container(keyedBy: JSONCodingKey.self)
//            try JSONAny.encode(to: &container, dictionary: dict)
//        } else {
//            var container = encoder.singleValueContainer()
//            try JSONAny.encode(to: &container, value: self.value)
//        }
//    }
//}
