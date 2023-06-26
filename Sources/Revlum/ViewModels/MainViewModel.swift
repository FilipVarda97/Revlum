//
//  MainViewModel.swift
//  
//
//  Created by Filip Varda on 31.05.2023..
//

import Foundation
import Combine

// MARK: - Input/Output
extension MainViewModel {
    enum Input {
        case openSdk
        case buildUrlToOpen(_ userId: String, urlToBuild: String)
    }
    enum Output {
        case locationFetched(_ location: String)
        case locationFetchFailed
        case builtUrl(_ url: URL)
    }
}

// MARK: - RevlumViewModel
class MainViewModel {
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()

    public func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .openSdk:
                    self?.fetchIpLocation()
                case .buildUrlToOpen(let userId, urlToBuild: let urlToBuild):
                    self?.buildUrl(with: userId, urlToBuild)
                }
            }
            .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
}

// MARK: - IP Location
private extension MainViewModel {
    private func fetchIpLocation() {
        guard let url = URL(string: "https://api.ipgeolocation.io/ipgeo?apiKey=ed892fc4ce30442b98d95827fd498b7a") else {
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, _) -> String in
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let countryCode = json["country_code2"] as? String else {
                    throw URLError(.badServerResponse)
                }
                return countryCode
            }
            .map { Output.locationFetched($0) }
            .replaceError(with: Output.locationFetched("HR"))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                self?.output.send(output)
            }
            .store(in: &cancellables)
    }

    private func buildUrl(with userID: String, _ urlToBuild: String) {
        var url = urlToBuild
        url = url.replacingOccurrences(of: "{userID}", with: userID)
        guard let builtUrl = URL(string: url) else {
            return
        }
        output.send(.builtUrl(builtUrl))
    }
}
