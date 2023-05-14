//
//  OffersViewModel.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

protocol OffersViewModelDelegate: AnyObject {
    func didLoadOffers()
    func didFailToLoadOffers()
    func didStartLoadingOffers()
    func didSelectOffer(_ offer: Offer)
}

class OffersViewModel: NSObject {
    private let apiService = APIService.shared
    weak var delegate: OffersViewModelDelegate?

    private var scrollViewOffset: CGPoint = CGPoint(x: 0, y: 40)
    private var cellViewModels: [OfferCellViewModel] = []
    private var offers: [Offer] = [] {
        didSet {
            cellViewModels.removeAll()
            for offer in offers {
                let viewModel = OfferCellViewModel(offer: offer)
                cellViewModels.append(viewModel)
            }
        }
    }

    public func loadOffers() {
        if cellViewModels.count > 0 && cellViewModels.count == offers.count { return }
        guard let apiKey = RevlumUserDefaultsService.getValue(of: String.self, for: .apiKey) else { return }
        let request = APIRequest(httpMethod: .get, queryParams: [URLQueryItem(name: "apikey", value: apiKey),
                                                                 URLQueryItem(name: "category", value: "offer"),
                                                                 URLQueryItem(name: "platform", value: "ios,desktop,all")])

        delegate?.didStartLoadingOffers()
        apiService.execute(request, expected: [Offer].self) { [weak self] result in
            switch result {
            case .success(let offers):
                self?.offers = offers
                self?.delegate?.didLoadOffers()
            case .failure(let error):
                print(error)
                self?.delegate?.didFailToLoadOffers()
            }
        }
    }

    public func getScrollViewOffset() -> CGPoint {
        return self.scrollViewOffset
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension OffersViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OfferTableViewCell.reuseIdentifier) as? OfferTableViewCell else { return UITableViewCell() }
        cell.configure(with: cellViewModels[indexPath.row], indexPath: indexPath)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollViewOffset.y == scrollView.contentOffset.y.rounded() { return }
        scrollViewOffset = CGPoint(x: 0, y: scrollView.contentOffset.y.rounded())
    }
}

// MARK: - OfferTableViewCellDelegate
extension OffersViewModel: OfferTableViewCellDelegate {
    func offerButtonPressed(_ indexPath: IndexPath) {
        delegate?.didSelectOffer(offers[indexPath.row])
    }
}
