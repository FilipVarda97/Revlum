//
//  RevlumImageLoader.swift
//  
//
//  Created by Filip Varda on 09.05.2023..
//

import UIKit

final class RevlumImageLoader {
    static let shared = RevlumImageLoader()
    private var dataCache = NSCache<NSString, NSData>()

    private init() {}

    public func dowloadImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = dataCache.object(forKey: key) as? Data {
            completion(.success(data))
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self?.dataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
