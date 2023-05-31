//
//  SurveysViewModel.swift
//  
//
//  Created by Filip Varda on 14.05.2023..
//

import UIKit
import Combine

extension SurveysViewModel {
    enum Input {
        case loadSurveys(_ location: String)
    }
    enum Output {
        case loadedSurveys
        case failedToLoadSurveys
        case selectedSurvey(_ survey: Survey)
        case startLoading
        case stopLoading
    }
}

class SurveysViewModel: NSObject {
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService.shared

    private var scrollViewOffset: CGPoint = CGPoint(x: 0, y: 40)
    private var cellViewModels: [SurveyCellViewModel] = []
    private var surveys: [Survey] = [] {
        didSet {
            cellViewModels.removeAll()
            for survey in surveys {
                let viewModel = SurveyCellViewModel(survey: survey)
                cellViewModels.append(viewModel)
            }
        }
    }

    public func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .loadSurveys(let location):
                    self?.loadSurveys(location)
                }
            }
            .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }

    func loadSurveys(_ location: String) {
        if cellViewModels.count > 0 && cellViewModels.count == surveys.count { return }
        guard let apiKey = RevlumUserDefaultsService.getValue(of: String.self, for: .apiKey) else { return }
        let request = APIRequest(httpMethod: .get, queryParams: [URLQueryItem(name: "apikey", value: apiKey),
                                                                 URLQueryItem(name: "category", value: "offer"),
                                                                 URLQueryItem(name: "platform", value: "ios,desktop,all")])

        output.send(.startLoading)
        apiService.execute(request, expected: [Survey].self) { [weak self] result in
            switch result {
            case .success(let surveys):
                self?.surveys = surveys
                self?.output.send(.stopLoading)
                self?.output.send(.loadedSurveys)
            case .failure:
                self?.output.send(.stopLoading)
                self?.output.send(.failedToLoadSurveys)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SurveysViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SurveyTableViewCell.reuseIdentifier) as? SurveyTableViewCell else { return UITableViewCell() }
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

// MARK: - SurveyTableViewCellDelegate
extension SurveysViewModel: SurveyTableViewCellDelegate {
    func surveyButtonPressed(_ indexPath: IndexPath) {
        output.send(.selectedSurvey(surveys[indexPath.row]))
    }
}
