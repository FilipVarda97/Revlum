//
//  RevlumImageLoader.swift
//  
//
//  Created by Filip Varda on 09.05.2023..
//

import UIKit

final class RevlumImageLoader {
    static let shared = RevlumImageLoader()
    private init() {}

    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}
