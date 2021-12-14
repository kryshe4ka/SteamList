//
//  NetworkDataManager.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import Alamofire

class NetworkDataManager: NSObject {
    static let shared = NetworkDataManager()
    let session: Session
    
    override init() {
        self.session = Session()
        super.init()
    }
    
    static func request(_ convertible: URLRequestConvertible) -> DataRequest {
        shared.session.request(convertible).validate()
    }
}

extension NetworkDataManager: NetworkManagerProtocol {
    
    func get<T: Decodable>(request: URLRequestConvertible, completion: @escaping (Result<T, Error>) -> Void)
    {
        NetworkDataManager.request(request).responseDecodable(of: T.self)
        { response in
            switch response.result {
            case .success(let responseObjects):
                completion(.success(responseObjects))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func buildRequestForFetchNews(appId: Int, count: Int) -> URLRequestConvertible {
        return APIRouter.fetchNewsForApp(appId, count)
    }
    
    func buildRequestForFetchAppDetails(appId: Int) -> URLRequestConvertible {
        return APIRouter.fetchAppDetails(appId)
    }
    
    func buildRequestForFetchApps() -> URLRequestConvertible {
        return APIRouter.fetchAllApps
    }
}
