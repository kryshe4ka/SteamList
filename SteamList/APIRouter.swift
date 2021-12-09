//
//  APIRouter.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    enum APIConstants {
        static let baseUrl = "https://api.steampowered.com"
    }
    
    case fetchAllApps
    case fetchAppDetails(Int)
    case fetchNewsForApp(Int, Int)
    
    var method: HTTPMethod {
        switch self {
        case .fetchAllApps:
            return .get
        case .fetchAppDetails:
            return .get
        case .fetchNewsForApp:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchAllApps:
            return "/ISteamApps/GetAppList/v2/"
        case .fetchAppDetails:
            return "/api/appdetails"
        case .fetchNewsForApp:
            return "/ISteamNews/GetNewsForApp/v2/"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .fetchAppDetails(let appId):
            return ["appids": appId]
        case .fetchNewsForApp(let appId, let count):
            return ["appid": appId, "count": count]
        case .fetchAllApps:
            return [:]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try APIConstants.baseUrl.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10*1000)
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
