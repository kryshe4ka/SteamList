//
//  NetworkDataManager.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import UIKit
import Alamofire

class NetworkDataManager: NSObject {
    static let shared = NetworkDataManager(configuration: URLSessionConfiguration.af.default)
    let session: Session
    
    init(configuration: URLSessionConfiguration) {
        self.session = Session(configuration: configuration)
        super.init()
    }
    
    func request(_ convertible: URLRequestConvertible) -> DataRequest {
        session.request(convertible).validate()
    }
    
    func download(_ url: String) -> DownloadRequest {
        session.download(url).validate()
    }
}

extension NetworkDataManager: NetworkManagerProtocol {
    func loadImage(urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        NetworkDataManager.shared.download(urlString).responseData { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                DispatchQueue.main.async {
                    guard let downloadedImage = UIImage(data: data) else { return }
                    completion(.success(downloadedImage))
                }
            }
        }
    }

    func get<T: Decodable>(request: URLRequestConvertible, completion: @escaping (Result<T, Error>) -> Void) {
        NetworkDataManager.shared.request(request).responseDecodable(of: T.self)
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
