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
    var configuration: URLSessionConfiguration!
    var networkDataManager: NetworkDataManager!
    
    override func setUpWithError() throws {
        configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        networkDataManager = NetworkDataManager(configuration: configuration)
    }

    override func tearDownWithError() throws {
        configuration = nil
        networkDataManager = nil
    }
    
    func testRequestGenerationForFetchApps() {
        let request = NetworkDataManager.shared.buildRequestForFetchApps()
        let testURL = URL(string: "https://api.steampowered.com/ISteamApps/GetAppList/v2/")
        XCTAssertEqual(try XCTUnwrap(request.asURLRequest().url), testURL) /// use the built-in XCTUnwrap function to verify that our generated request didn’t end up being nil
    }

    func testRequestGenerationForFetchNews() {
        let request = NetworkDataManager.shared.buildRequestForFetchNews(appId: MockedData.appId, count: MockedData.count)
        let testURL = URL(string: "https://api.steampowered.com/ISteamNews/GetNewsForApp/v2/?appid=10&count=10")
        XCTAssertEqual(try XCTUnwrap(request.asURLRequest().url), testURL)
    }
    
    func testRequestGenerationForFetchAppDetails() {
        let request = NetworkDataManager.shared.buildRequestForFetchAppDetails(appId: MockedData.appId)
        let testURL = URL(string: "https://store.steampowered.com/api/appdetails?appids=10")
        XCTAssertEqual(try XCTUnwrap(request.asURLRequest().url), testURL)
    }
    
    func testAppsFetching() {
        let request = NetworkDataManager.shared.buildRequestForFetchApps()
        let apiEndpoint = try! XCTUnwrap(request.asURLRequest().url)
        let expectedObject = MockedData.app
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
    
    func testNewsFetching() {
        let request = NetworkDataManager.shared.buildRequestForFetchNews(appId: MockedData.appId, count: MockedData.count)
        let apiEndpoint = try! XCTUnwrap(request.asURLRequest().url)
        let expectedObject = MockedData.appNews
        let requestExpectation = expectation(description: "Request should finish")
        let mockedData = try! JSONEncoder().encode(expectedObject)
        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()
        
        networkDataManager
            .request(request)
            .responseDecodable(of: AppNews.self) { (response) in
                XCTAssertNil(response.error)
                XCTAssertEqual(response.value, expectedObject)
                requestExpectation.fulfill()
            }.resume()
        
        wait(for: [requestExpectation], timeout: 5.0)
    }
    
    func testAppDetailsFetching() {
        let request = NetworkDataManager.shared.buildRequestForFetchAppDetails(appId: MockedData.appId)
        let apiEndpoint = try! XCTUnwrap(request.asURLRequest().url)
        let expectedObject = MockedData.appDetails
        let requestExpectation = expectation(description: "Request should finish")
        let jsonObject = MockedData.jsonObject
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
            XCTFail()
        }
    }
    
    func testImageDownloading() {
        let urlString = "https://cdn.akamai.steamstatic.com/steam/apps/10/header.jpg?t=1602535893"
        let originalURL = MockedData.imageFileUrl
        let mockedData = MockedData.imageFileUrl.data
        let mock = Mock(url: originalURL, ignoreQuery: true, dataType: .imagePNG, statusCode: 200, data: [
                    .get: mockedData])
        mock.register()
        let requestExpectation = expectation(description: "Data request should succeed")

        networkDataManager.download(urlString).responseData { response in
            XCTAssertNil(response.error)
            guard let data = response.value else {
                XCTFail("Data is nil")
                return
            }
            guard let image: UIImage = UIImage(data: data) else {
                XCTFail("Invalid data \(String(describing: data))")
                return
            }
            XCTAssertNotNil(image, "Image should be not nil")
            
            requestExpectation.fulfill()
        }.resume()
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    /// it should return the error we requested from the mock when we pass in an Error.
    func testMockRequestReturningError() {
        let expectation = expectation(description: "Data request should succeed")
        let originalURL = URL(string: MockedData.fetchAppsUrl)!
        let request = NetworkDataManager.shared.buildRequestForFetchApps()

        Mock(url: originalURL, dataType: .json, statusCode: 500, data: [.get: Data()], requestError: TestExampleError.example).register()

        networkDataManager.request(request).responseDecodable(of: App.self) { (response) in
            XCTAssertNil(response.value)
            XCTAssertNotNil(response.error)
            if let error = response.error {
                XCTAssertTrue(String(describing: error).contains("TestExampleError"))
            }
            expectation.fulfill()
        }.resume()

        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testMockDownloadReturningError() {
        let urlString = "https://cdn.akamai.steamstatic.com/steam/apps/10/header.jpg?t=1602535893"
        let originalURL = MockedData.imageFileUrl
        let mockedData = MockedData.imageFileUrl.data
        let mock = Mock(url: originalURL, ignoreQuery: true, dataType: .imagePNG, statusCode: 500, data: [
                    .get: mockedData], requestError: TestExampleError.example)
        mock.register()
        let requestExpectation = expectation(description: "Data request should succeed")

        networkDataManager.download(urlString).responseData { response in
            XCTAssertNil(response.value)
            XCTAssertNotNil(response.error)
            if let error = response.error {
                XCTAssertTrue(String(describing: error).contains("TestExampleError"))
            }
            requestExpectation.fulfill()
        }.resume()
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
