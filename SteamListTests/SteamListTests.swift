//
//  SteamListTests.swift
//  SteamListTests
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import XCTest
import Mocker
import Alamofire
import SwiftyJSON
@testable import SteamList

class SteamListTests: XCTestCase {
    
    // custom urlsession for mock network calls
    var urlSession: URLSession!
    var dataManager: NetworkDataManager!
    

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRequestGenerationForFetchApps() {
        let request = NetworkDataManager.shared.buildRequestForFetchApps()
        let testURL = URL(string: "https://api.steampowered.com/ISteamApps/GetAppList/v2/")
        XCTAssertEqual(try XCTUnwrap(request.asURLRequest().url), testURL) /// use the built-in XCTUnwrap function to verify that our generated request didn’t end up being nil

    }

    func testRequestGenerationForFetchNews() {
        let request = NetworkDataManager.shared.buildRequestForFetchNews(appId: 1, count: 10)
        let testURL = URL(string: "https://api.steampowered.com/ISteamNews/GetNewsForApp/v2/?appid=1&count=10")
        XCTAssertEqual(try XCTUnwrap(request.asURLRequest().url), testURL)
    }
    
    func testRequestGenerationForFetchAppDetails() {
        let request = NetworkDataManager.shared.buildRequestForFetchAppDetails(appId: 1)
        let testURL = URL(string: "https://store.steampowered.com/api/appdetails?appids=1")
        XCTAssertEqual(try XCTUnwrap(request.asURLRequest().url), testURL)
    }
    
    func testAppsFetching() {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        let networkDataManager = NetworkDataManager(configuration: configuration)
        
        let request = NetworkDataManager.shared.buildRequestForFetchApps()
        let apiEndpoint = try! XCTUnwrap(request.asURLRequest().url)
        let expectedObject = App(applist: Applist(apps: [AppElement(appid: 1, name: "Test Game")]))
        let requestExpectation = expectation(description: "Request should finish")
        
        let mockedData = try! JSONEncoder().encode(expectedObject) /// instance is converted to JSON data using the JSON encoder
        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register() /// a Mock instance is created using the JSON data and API endpoint. The data type is set to JSON and the expected status code is set to 200
        
        networkDataManager
            .request(request)
            .responseDecodable(of: App.self) { (response) in
                XCTAssertNil(response.error)
                XCTAssertEqual(response.value, expectedObject)
                requestExpectation.fulfill()
            }.resume()
        
        wait(for: [requestExpectation], timeout: 5.0)
    }
    
    func testAppDetailsFetching() {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        let networkDataManager = NetworkDataManager(configuration: configuration)
        
        let request = NetworkDataManager.shared.buildRequestForFetchAppDetails(appId: 1)
        let apiEndpoint = try! XCTUnwrap(request.asURLRequest().url)
        
        let expectedObject = AppDetails(name: "Counter-Strike", steamAppid: 10, isFree: false, shortDescription: "Play the world's number ...", headerImage: "https://cdn.akamai.steamstatic.com/steam/apps/10/header.jpg?t=1602535893", priceOverview: PriceOverview(currency: "USD", initial: 629, priceOverviewFinal: 629, discountPercent: 0, initialFormatted: "", finalFormatted: "$6.29 USD"), platforms: Platforms(windows: true, mac: true, linux: true), genres: [Genre(genreDescription: "Action")], screenshots: [Screenshot(pathFull: "https://cdn.akamai.steamstatic.com/steam/apps/10/0000000132.1920x1080.jpg?t=1602535893")], releaseDate: ReleaseDate(date: "1 Nov, 2000"))
        
        let requestExpectation = expectation(description: "Request should finish")
        
        let jsonObject = JSON([
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
        
        do {
            let jsonData = try jsonObject.rawData()
            let mockedData = jsonData
            let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: mockedData])
            mock.register()
            
            networkDataManager
                .request(request)
                .responseDecodable(of: DecodedObject.self) { (response) in
                    XCTAssertNil(response.error)
                    let appDetails = response.value?.decodedObject.data
                    XCTAssertEqual(appDetails, expectedObject)
                    requestExpectation.fulfill()
                }.resume()
            
            wait(for: [requestExpectation], timeout: 5.0)
            
        } catch {
            print("Error \(error)")
            XCTAssertTrue(false)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
