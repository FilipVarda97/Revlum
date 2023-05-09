//
//  RevlumUserDefaultsService.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import Foundation

enum RevlumUserDefaultsKeys: String {
    case apiKey = "revlum-user-defaults-api-key"
    case userId = "revlum-user-defaults-user-id"
}

struct RevlumUserDefaultsService {
    static func getValue<T: Codable>(of type: T.Type, for key: RevlumUserDefaultsKeys) -> T? {
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.data(forKey: key.rawValue) {
            let decoder = JSONDecoder()
            return try? decoder.decode(T.self, from: data)
        }
        return nil
    }

    static func setValue<T: Codable>(_ value: T, for key: RevlumUserDefaultsKeys) {
        let userDefaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(value) {
            userDefaults.set(data, forKey: key.rawValue)
        } else {
            fatalError("Failed to encode value: \(value) for key: \(key.rawValue)")
        }
    }
}
