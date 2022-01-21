//
//  DataManagerTests.swift
//  SteamListTests
//
//  Created by Liza Kryshkovskaya on 20.01.22.
//

import XCTest
import Mocker
import Alamofire
import SwiftyJSON
@testable import SteamList

class DataManagerTests: XCTestCase {
    var dataManager: CoreDataManagerStub!
    
    override func setUpWithError() throws {
        dataManager = CoreDataManagerStub()
    }
    
    override func tearDownWithError() throws {
        dataManager = nil
    }
    
    func testFetchApps() {
        dataManager.fetchApps { result in
            switch result {
            case .success(let apps):
                XCTAssertEqual(apps, MockedData.app.applist.apps)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testFetchAppDetails() {
        dataManager.fetchAppDetails(appId: MockedData.appId) { result in
            switch result {
            case .success(let appDetails):
                XCTAssertEqual(appDetails, MockedData.appDetails)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testFetchNews() {
        dataManager.fetchNews { result in
            switch result {
            case .success(let news):
                XCTAssertEqual(news, MockedData.appNews.appnews?.newsitems)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testFetchFavoritesSortedByName() {
        let sortedArray = dataManager.fetchFavoriteApps(sortKey: SortingKey.name)
        XCTAssertEqual(sortedArray, MockedData.favAppsSortedByName)
    }
    
    func testFetchFavoritesSortedByPrice() {
        let sortedArray = dataManager.fetchFavoriteApps(sortKey: SortingKey.price)
        XCTAssertEqual(sortedArray, MockedData.favAppsSortedByPrice)
    }
    
    func testAddToFavorites() {
        let expectedCount = dataManager.favApps.count + 1
        let app = AppElement(appid: 4, name: "D Test Game", isFavorite: true, price: "$4.0", priceRawValue: 4)
        dataManager.addAppToFavorites(app: app)
        XCTAssertEqual(expectedCount, dataManager.favApps.count)
    }
    
    func testRemoveAppFromFavorites() {
        let expectedCount = dataManager.favApps.count - 1
        let app = AppElement(appid: 1, name: "C Test Game", isFavorite: true, price: "$2.0", priceRawValue: 2)
        dataManager.removeAppFromFavorites(app: app)
        XCTAssertEqual(expectedCount, dataManager.favApps.count)
    }
}
