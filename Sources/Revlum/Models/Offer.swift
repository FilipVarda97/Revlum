//
//  File.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import Foundation

struct Offer: Codable {
    let title: String
    let description: String
    let image: String
    let revenue: String
    let category: String
    let countries: [String]
    let offerID: String
    let platform: String
    let url: String
}

struct Survey {
    let title: String
    let description: String
    let image: String
    let revenue: String
}
