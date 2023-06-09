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
        case searchOffers(_ searchText: String)
    }
    enum Output {
        case offersLoaded
        case offersFailedToLoad
        case startLoading
        case stopLoading
        case openOffer(_ offer: Offer)
        case openFilterView(_ selectedSortType: SortType, _ selectedFilterType: FilterType)
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

    private var selectedFilterType: FilterType = .none
    private var selectedSortType: SortType = .none
    private var isSearching: Bool = false

    private var offers: [Offer] = [] {
        didSet {
            updateCellViewModels()
        }
    }
    private var filteredOffers: [Offer]?

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

// MARK: - Sort/Filter/Search
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
        self.selectedFilterType = filterType
        switch filterType {
        case .ios:
            filteredOffers = offers.filter { $0.platform == "ios" }
        case .web:
            filteredOffers = offers.filter { $0.platform == "desktop" }
        case .none:
            filteredOffers = nil
        }
        if selectedSortType != .none {
            sortOffers(selectedSortType)
        } else {
            updateCellViewModels()
        }
    }

    private func sortOffers(_ sortType: SortType) {
        self.selectedSortType = sortType
        switch sortType {
        case .ascending:
            if selectedFilterType == .none {
                offers = offers.sorted {
                    let revenue1 = Double($0.revenue.components(separatedBy: " ")[0]) ?? 0
                    let revenue2 = Double($1.revenue.components(separatedBy: " ")[0]) ?? 0
                    return revenue1 < revenue2
                }
            } else {
                filteredOffers = filteredOffers?.sorted {
                    let revenue1 = Double($0.revenue.components(separatedBy: " ")[0]) ?? 0
                    let revenue2 = Double($1.revenue.components(separatedBy: " ")[0]) ?? 0
                    return revenue1 < revenue2
                }
            }
        case .descending:
            if selectedFilterType == .none {
                offers = offers.sorted {
                    let revenue1 = Double($0.revenue.components(separatedBy: " ")[0]) ?? 0
                    let revenue2 = Double($1.revenue.components(separatedBy: " ")[0]) ?? 0
                    return revenue1 > revenue2
                }
            } else {
                filteredOffers = filteredOffers?.sorted {
                    let revenue1 = Double($0.revenue.components(separatedBy: " ")[0]) ?? 0
                    let revenue2 = Double($1.revenue.components(separatedBy: " ")[0]) ?? 0
                    return revenue1 > revenue2
                }
            }
        case .none:
            if selectedFilterType == .none && !isSearching {
                filteredOffers = nil
            }
        }
        updateCellViewModels()
    }

    private func searchOffers(_ searchText: String) {
        if !searchText.isEmpty {
            isSearching = true
        } else {
            isSearching = false
        }
        guard !searchText.isEmpty,
              selectedSortType == .none,
              selectedFilterType == .none else {
            filteredOffers = offers
            sortOffers(selectedSortType)
            return
        }

        if filteredOffers == nil {
            filteredOffers = offers.filter { $0.title.lowercased().contains(searchText.lowercased())  }
        } else {
            filteredOffers = filteredOffers?.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        sortOffers(selectedSortType)
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
        return cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OfferTableViewCell.reuseIdentifier) as? OfferTableViewCell else { return UITableViewCell() }
        cell.configure(with: cellViewModels[indexPath.row], indexPath: indexPath)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 169
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchOffersTableHeaderView.reuseIdentifier) as? SearchOffersTableHeaderView else { return nil }
        view.delegate = self
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        output.send(.forceEndEditing)
    }
}

// MARK: - OfferTableViewCellDelegate
extension OffersViewModel: RevlumCellDelegate {
    func buttonPressed(_ selectedIndexPath: IndexPath) {
        output.send(.openOffer(offers[selectedIndexPath.row]))
    }
}

// MARK: - SearchCellDelegate
extension OffersViewModel: SearchHeaderDelegate {
    func openFilterViewPressed() {
        output.send(.openFilterView(selectedSortType, selectedFilterType))
    }
    func textFieldTextChanged(_ text: String) {
        searchOffers(text)
    }
}
