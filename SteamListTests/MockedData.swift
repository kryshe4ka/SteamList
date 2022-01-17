//
//  Stubs.swift
//  SteamListTests
//
//  Created by Liza Kryshkovskaya on 15.01.22.
//

//import XCTest
//import Mocker
//import Alamofire
import SwiftyJSON
@testable import SteamList
import Foundation

enum TestExampleError: Error, LocalizedError {
    case example
    var errorDescription: String { "example" }
}

public final class MockedData {
    static let appId = 10
    static let count = 10
    static let imageFileUrl = URL(string: "https://cdn.akamai.steamstatic.com/steam/apps/10/header.jpg?t=1602535893")!
    static let fetchAppsUrl = "https://api.steampowered.com/ISteamApps/GetAppList/v2/"
    static let fetchAppDetailsUrl = "https://store.steampowered.com/api/appdetails?appids=10"
    static let fetchNewsUrl = "https://api.steampowered.com/ISteamNews/GetNewsForApp/v2/?appid=10&count=10"
    
    static let app = App(applist: Applist(apps: [AppElement(appid: appId, name: "Test Game")]))
    
    static let appNews = AppNews(appnews: Appnews(appid: 1, newsitems: [Newsitem(gid: "1", title: "Test News", author: "LK", contents: "Test content", date: 12345678, appid: 1), Newsitem(gid: "2", title: "Test News 2", author: "LK", contents: "Test content 2", date: 12345679, appid: 1)], count: 2))
    
    static let appDetails = AppDetails(name: "Counter-Strike", steamAppid: 10, isFree: false, shortDescription: "Play the world's number ...", headerImage: "https://cdn.akamai.steamstatic.com/steam/apps/10/header.jpg?t=1602535893", priceOverview: PriceOverview(currency: "USD", initial: 629, priceOverviewFinal: 629, discountPercent: 0, initialFormatted: "", finalFormatted: "$6.29 USD"), platforms: Platforms(windows: true, mac: true, linux: true), genres: [Genre(genreDescription: "Action")], screenshots: [Screenshot(pathFull: "https://cdn.akamai.steamstatic.com/steam/apps/10/0000000132.1920x1080.jpg?t=1602535893")], releaseDate: ReleaseDate(date: "1 Nov, 2000"))
    
    static let jsonObject = JSON([
        "10": [
            "success": true,
            "data": [
                "type": "game",
                "name": "Counter-Strike",
                "steam_appid": 10,
                "required_age": 0,
                "is_free": false,
                "detailed_description": "Play the world's number ...",
                "about_the_game": "Play the world's number ...",
                "short_description": "Play the world's number ...",
                "supported_languages": "English",
                "header_image": "https://cdn.akamai.steamstatic.com/steam/apps/10/header.jpg?t=1602535893",
                "pc_requirements": [
                    "minimum": "500 mhz processor, 96mb ram, 16mb video card"
                ],
                "mac_requirements": [
                    "minimum": "Minimum: OS X"
                ],
                "linux_requirements": [
                    "minimum":"Minimum: Linux Ubuntu"
                ],
                "developers": ["Valve"],
                "publishers": ["Valve"],
                "price_overview": [
                    "currency":"USD",
                    "initial":629,
                    "final":629,
                    "discount_percent":0,
                    "initial_formatted":"",
                    "final_formatted":"$6.29 USD"
                    ],
                "packages": [574941,7],
                "package_groups": [
                    [
                        "name":"default",
                        "title":"Buy Counter-Strike",
                        "description":"",
                        "selection_text": "Select a purchase option",
                        "save_text":"",
                        "display_type":0,
                        "is_recurring_subscription":"false",
                        "subs": [
                            [
                                "packageid":7,
                                "percent_savings_text":" ",
                                "percent_savings":0,
                                "option_text":"Counter-Strike: Condition Zero - $6.29 USD",
                                "option_description":"",
                                "can_get_free_license":"0",
                                "is_free_license":false,
                                "price_in_cents_with_discount":629
                            ],
                            [
                                "packageid":574941,
                                "percent_savings_text":" ",
                                "percent_savings":0,
                                "option_text":"Counter-Strike - Commercial License - $6.29 USD",
                                "option_description":"",
                                "can_get_free_license":"0",
                                "is_free_license":false,
                                "price_in_cents_with_discount":629
                            ]
                        ]
                    ]
                ],
                "platforms": [
                    "windows":true,
                    "mac":true,
                    "linux":true
                ],
                "metacritic": [
                    "score":88,
                    "url":"https://www.metacritic.com/game/pc/counter-strike?ftag=MCD-06-10aaa1f"
                ],
                "categories":[
                    [
                        "id":1,
                        "description":"Multi-player"
                    ],
                    [
                        "id":49,
                        "description":"PvP"
                    ],
                    [
                        "id":36,
                        "description":"Online PvP"
                    ],
                    [
                        "id":37,
                        "description":"Shared/Split Screen PvP"
                    ],
                    [
                        "id":8,
                        "description":"Valve Anti-Cheat enabled"
                    ]
                ],
                "genres": [
                    [
                        "id":"1",
                        "description":"Action"
                    ]
                ],
                "screenshots":[
                        [
                            "id":0,
                            "path_thumbnail":"https://cdn.akamai.steamstatic.com/steam/apps/10/0000000132.600x338.jpg?t=1602535893",
                            "path_full":"https://cdn.akamai.steamstatic.com/steam/apps/10/0000000132.1920x1080.jpg?t=1602535893"
                        ]
                    ],
                "recommendations": [
                    "total":117376
                ],
                "release_date": [
                    "coming_soon":false,
                    "date":"1 Nov, 2000"
                ],
                "support_info": [
                    "url":"http://steamcommunity.com/app/10",
                    "email":""
                ],
                "background":"https://cdn.akamai.steamstatic.com/steam/apps/10/page_bg_generated_v6b.jpg?t=1602535893",
                "content_descriptors": [
                    "ids":[2,5],
                    "notes":"Includes intense violence and blood."
                ]
            ]
        ]
    ])
}

internal extension URL {
    /// Returns a `Data` representation of the current `URL`. Force unwrapping as it's only used for tests.
    var data: Data {
        return try! Data(contentsOf: self)
    }
}
