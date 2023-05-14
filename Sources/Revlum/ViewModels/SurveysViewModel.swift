//
//  SurveysViewModel.swift
//  
//
//  Created by Filip Varda on 14.05.2023..
//

import UIKit

protocol SurveysViewModelDelegate: AnyObject {
    func didFetchSurveys()
}

class SurveysViewModel: NSObject {
    private let apiService = APIService.shared
    private var offers: [Offer] = [Offer]()
    weak var delegate: OffersViewModelDelegate?

    public func fetchOffers() {
        guard let apiKey = RevlumUserDefaultsService.getValue(of: String.self, for: .apiKey) else { return }
        let request = APIRequest(httpMethod: .get, queryParams: [URLQueryItem(name: "apikey", value: apiKey),
                                                                 URLQueryItem(name: "category", value: "offer"),
                                                                 URLQueryItem(name: "platform", value: "ios,desktop,all")])
        apiService.execute(request, expected: [Offer].self) { [weak self] result in
            switch result {
            case .success(let offers):
                self?.offers = offers
                self?.delegate?.didFetchOffers()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SurveysViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OfferTableViewCell.reuseIdentifier) as? OfferTableViewCell else { return UITableViewCell() }
        cell.configure(with: offers[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
}

