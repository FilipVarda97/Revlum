//
//  OffersViewModel.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import Foundation

protocol OffersViewModelDelegate: AnyObject {
    func didFetchOffers(_ offers: [Offer])
}

class OffersViewModel {
    private let apiService = APIService.shared
    private var offers: [Offer]?

    public func fetchOffers() {
        guard let apiKey = RevlumUserDefaultsService.getValue(of: String.self, for: .apiKey) else { return }
        let request = APIRequest(httpMethod: .get, queryParams: [URLQueryItem(name: "apikey", value: apiKey)])
        apiService.execute(request, expected: [Offer].self) { result in
            switch result {
            case .success(let offers):
                print(offers)
            case .failure(let error):
                print(error)
            }
        }
    }
}
