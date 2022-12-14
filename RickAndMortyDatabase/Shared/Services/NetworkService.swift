//
//  NetworkService.swift
//  RickAndMortyDatabase
//
//  Created by Thomas Noury  on 10/11/2022.
//

import Foundation

enum ServiceError: Error, Equatable {
    case urlFormatError
    case transportError
    case decodingError
    case requestError(Int)
}

protocol NetworkServiceProtocol {
    func makeGetRequest<T: Decodable>(url: String, responseType: T.Type, _ completion: @escaping (_ result: Result<T, ServiceError>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    static let shared: NetworkServiceProtocol = NetworkService(urlSession: URLSession.shared)
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func makeGetRequest<T: Decodable>(url: String, responseType: T.Type, _ completion: @escaping (_ result: Result<T, ServiceError>) -> Void) {
        guard let url = URL(string: "\(MainConfig.apiUrl)\(url)") else {
            completion(.failure(.urlFormatError))
            return
        }
        let task = self.urlSession.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.transportError))
                return
            }
            switch response.statusCode {
            case 200:
                guard let data = data else { return }
                do {
                    let responseData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(responseData))
                } catch {
                    completion(.failure(.decodingError))
                }
            case 400...599:
                completion(.failure(.requestError(response.statusCode)))
            default:
                // We do nothing for all other codes
                break
            }
        }
        task.resume()
    }
}
