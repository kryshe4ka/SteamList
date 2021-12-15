//
//  NetworkManagerProtocol.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Alamofire
import UIKit

protocol NetworkManagerProtocol {
    func get<T: Decodable>(request: URLRequestConvertible, completion: @escaping (Result<T, Error>) -> Void)
    func loadImage(urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}
