//
//  NetworkManagerProtocol.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 9.12.21.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func get<T: Decodable>(request: URLRequestConvertible, completion: @escaping (Result<T, Error>) -> Void)
}
