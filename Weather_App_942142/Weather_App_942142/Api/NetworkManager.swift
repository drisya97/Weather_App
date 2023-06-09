//
//  NetworkManager.swift
//  Weather_App_942142
//
//  Created by Drisya Sudevan on 07/06/23.
//

import Foundation
import UIKit

enum ApiKey : String {
    case key = "6883d4c8a0ee5b77a7a72ba33f28da0f"
}

enum NetworkError : Error {
    case timeOut
    case NoDataAvailable
    case InvalidURL
}

enum HttpMethods: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

typealias ResposeHandler<T> = (Result<T, NetworkError>) -> Void

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}

protocol NetworkManager {

    func getData<T: Decodable>(with urlStr: String, method : HttpMethods, parameters : [String : Any], decode: @escaping (Decodable) -> T?, completionHandler: @escaping ResposeHandler<T>)
}

extension NetworkManager {
        
    func getData<T: Decodable>(with urlStr : String , method : HttpMethods, parameters : [String : Any], decode: @escaping (Decodable) -> T?, completionHandler : @escaping ResposeHandler<T>) {

        guard let url = URL(string: "\(urlStr)\(ApiKey.key.rawValue)") else {
            
            completionHandler(.failure(.InvalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard data != nil else {
                completionHandler(.failure(NetworkError.timeOut))
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data!)

                DispatchQueue.main.async {
                    completionHandler(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.NoDataAvailable))
                }
            }

        }.resume()

    }
    
}
