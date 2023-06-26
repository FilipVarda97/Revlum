//
//  OfferCellViewModel.swift
//  
//
//  Created by Filip Varda on 14.05.2023..
//

import UIKit
import Foundation

/// ViewModel that manages OfferTableViewCell logic
final class OfferCellViewModel {
    enum OfferType: String {
        case ios = "ios"
        case desktop = "desktop"
        case all = "all"
    }

    public var offerTitle: String {
        return offer.title
    }
    public var offerDescription: String {
        return offer.description
    }
    public var offerRevenue: String {
        return offer.revenue
    }
    public var offerPlatform: OfferType {
        return OfferType(rawValue: offer.platform) ?? .ios
    }
    private let offer: Offer

    init(offer: Offer) {
        self.offer = offer
    }

    //MARK: - Implementation
    public func fetchImage(completion: @escaping(Result<Data, Error>) -> Void) {
        guard let url = URL(string: offer.image) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RevlumImageLoader.shared.dowloadImage(url: url, completion: completion)
    }
}
