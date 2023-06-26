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
    public var offerRevenue: NSAttributedString {
        let components = offer.revenue.components(separatedBy: " ")
        let numberAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16, weight: .heavy)]
        let textAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16)]
        let numberPart = NSMutableAttributedString(string: "+ \(components[0]) ", attributes: numberAttributes)
        let textPart = NSAttributedString(string: components[1], attributes: textAttributes)

        numberPart.append(textPart)
        return numberPart
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
