//
//  OffersViewModel.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit
import Combine

// MARK: - Input/Output
extension OffersViewModel {
    enum Input {
        case loadOffers(_ location: String)
    }
    enum Output {
        case offersLoaded
        case offersFailedToLoad
        case startLoading
        case stopLoading
        case openOffer(_ offer: Offer)
    }
}

// MARK: - RevlumViewModel
class OffersViewModel: NSObject {
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService.shared
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

    public func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .loadOffers(let location):
                    self?.loadOffers(location)
                }
            }
            .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
}

//MARK: - Loading offers
extension OffersViewModel {
    public func loadOffers(_ location: String) {
        if cellViewModels.count > 0 && cellViewModels.count == offers.count { return }

        guard let apiKey = RevlumUserDefaultsService.getValue(of: String.self, for: .apiKey) else { return }
        let request = APIRequest(httpMethod: .get, queryParams: [URLQueryItem(name: "apikey", value: apiKey),
                                                                 URLQueryItem(name: "category", value: "offer"),
                                                                 URLQueryItem(name: "platform", value: "ios,desktop,all")])

        output.send(.startLoading)
        apiService.execute(request, expected: [Offer].self) { [weak self] result in
            switch result {
            case .success(let offers):
                self?.offers = offers
                self?.output.send(.stopLoading)
                self?.output.send(.offersLoaded)
            case .failure:
                self?.output.send(.stopLoading)
                self?.output.send(.offersFailedToLoad)
            }
        }
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
        return 153
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollViewOffset.y == scrollView.contentOffset.y.rounded() { return }
        scrollViewOffset = CGPoint(x: 0, y: scrollView.contentOffset.y.rounded())
    }
}

// MARK: - OfferTableViewCellDelegate
extension OffersViewModel: RevlumCellDelegate {
    func buttonPressed(_ selectedIndexPath: IndexPath) {
        output.send(.openOffer(offers[selectedIndexPath.row]))
    }
}
