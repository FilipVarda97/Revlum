//
//  APIService.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import Foundation

/// Service that can make a API call if provided with APIRequest object
final class APIService {
    static let shared = APIService()

    // MARK: - Init
    private init() {}

    /// An enum with coresponding errors for simpler error handling and naming
    enum APIServiceError: Error {
        case failedToCreateRequest
        case failedToFetchData
        case failedToDecodeData
    }

    // MARK: - Implementation
    /// Executing the request.
    /// Parameter T is generic type that has to comfort to Codable protocol.
    public func execute<T: Codable>(_ request: APIRequest,
                                    expected type: T.Type,
                                    completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = request.url else {
            completion(.failure(APIServiceError.failedToCreateRequest))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard error == nil, let data = data else {
                completion(.failure(error ?? APIServiceError.failedToFetchData))
                return
            }
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

