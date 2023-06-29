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
        case filterOffers(_ filterType: FilterType)
        case sortOffers(_ sortType: SortType)
        case searchOffers(_ searchText: String?)
    }
    enum Output {
        case offersLoaded
        case offersFailedToLoad
        case startLoading
        case stopLoading
        case openOffer(_ offer: Offer)
        case openFilterView
        case forceEndEditing
        case reloadTable
    }
}

// MARK: - RevlumViewModel
class OffersViewModel: NSObject {
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService.shared
    private var cellViewModels: [OfferCellViewModel] = []

    private var offers: [Offer] = [] {
        didSet {
            updateCellViewModels()
        }
    }
    private var filteredOffers: [Offer]? {
        didSet {
            updateCellViewModels()
        }
    }

    public func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .loadOffers(let location):
                    self?.loadOffers(location)
                case .filterOffers(let filterType):
                    self?.filterOffers(filterType)
                case .sortOffers(let sortType):
                    self?.sortOffers(sortType)
                case .searchOffers(let searchText):
                    self?.searchOffers(searchText)
                }
            }
            .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
}

private extension OffersViewModel {
    private func updateCellViewModels() {
        cellViewModels.removeAll()
        if filteredOffers == nil {
            offers.forEach {
                let viewModel = OfferCellViewModel(offer: $0)
                cellViewModels.append(viewModel)
            }
        } else {
            filteredOffers!.forEach {
                let viewModel = OfferCellViewModel(offer: $0)
                cellViewModels.append(viewModel)
            }
        }
        output.send(.reloadTable)
    }

    private func filterOffers(_ filterType: FilterType) {
        switch filterType {
        case .ios:
            filteredOffers = offers.filter { $0.platform == "ios" }
        case .web:
            filteredOffers = offers.filter { $0.platform == "desktop" }
        case .none:
            filteredOffers = offers.filter { $0.platform == "all" }
        }
        updateCellViewModels()
    }

    private func sortOffers(_ sortType: SortType) {
        switch sortType {
        case .ascending:
            filteredOffers = filteredOffers?.sorted { $0.revenue < $1.revenue }
        case .descending:
            filteredOffers = filteredOffers?.sorted { $0.revenue > $1.revenue }
        case .none:
            break
        }
        updateCellViewModels()
    }

    private func searchOffers(_ searchText: String?) {
        guard let searchText = searchText, !searchText.isEmpty else {
            filteredOffers = offers
            return
        }

        filteredOffers = filteredOffers?.filter { $0.title.lowercased() == searchText.lowercased() }
        updateCellViewModels()
    }
}

//MARK: - Loading offers
extension OffersViewModel {
    public func loadOffers(_ location: String) {
        if cellViewModels.count > 0 && cellViewModels.count == offers.count { return }

        guard let apiKey = RevlumUserDefaultsService.getValue(of: String.self, for: .apiKey) else { return }
        let request = APIRequest(httpMethod: .get, queryParams: [URLQueryItem(name: "apikey", value: apiKey),
                                                                 URLQueryItem(name: "category", value: "offer"),
                                                                 URLQueryItem(name: "countries", value: location),
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
        return cellViewModels.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchOffersTableViewCell.reuseIdentifier) as? SearchOffersTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OfferTableViewCell.reuseIdentifier) as? OfferTableViewCell else { return UITableViewCell() }
            cell.configure(with: cellViewModels[indexPath.row - 1], indexPath: indexPath)
            cell.delegate = self
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        } else {
            return 169
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        output.send(.forceEndEditing)
    }
}

// MARK: - OfferTableViewCellDelegate
extension OffersViewModel: RevlumCellDelegate {
    func buttonPressed(_ selectedIndexPath: IndexPath) {
        output.send(.openOffer(offers[selectedIndexPath.row - 1]))
    }
}

extension OffersViewModel: SearchCellDelegate {
    func openFilterViewPressed() {
        output.send(.openFilterView)
    }

    func textFieldTextChanged(_ text: String) {
        searchOffers(text)
    }
}
