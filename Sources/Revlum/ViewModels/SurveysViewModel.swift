//
//  SurveysViewModel.swift
//  
//
//  Created by Filip Varda on 14.05.2023..
//

import UIKit

protocol SurveysViewModelDelegate: AnyObject {
    func didLoadSurveys()
    func didFailToLoadSurveys()
    func didStartLoadingSurveys()
    func selectedSurvey(_ survey: Survey)
}

class SurveysViewModel: NSObject {
    private let apiService = APIService.shared
    weak var delegate: SurveysViewModelDelegate?

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

    func loadSurveys() {
        if cellViewModels.count > 0 && cellViewModels.count == surveys.count { return }
        guard let apiKey = RevlumUserDefaultsService.getValue(of: String.self, for: .apiKey) else { return }
        let request = APIRequest(httpMethod: .get, queryParams: [URLQueryItem(name: "apikey", value: apiKey),
                                                                 URLQueryItem(name: "category", value: "offer"),
                                                                 URLQueryItem(name: "platform", value: "ios,desktop,all")])

        delegate?.didStartLoadingSurveys()
        apiService.execute(request, expected: [Survey].self) { [weak self] result in
            switch result {
            case .success(let surveys):
                self?.surveys = surveys
                self?.delegate?.didLoadSurveys()
            case .failure(let error):
                print(error)
            }
        }
    }

    func getScrollViewOffset() -> CGPoint {
        return scrollViewOffset
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
        return 155
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollViewOffset.y == scrollView.contentOffset.y.rounded() { return }
        scrollViewOffset = CGPoint(x: 0, y: scrollView.contentOffset.y.rounded())
    }
}

// MARK: - SurveyTableViewCellDelegate
extension SurveysViewModel: SurveyTableViewCellDelegate {
    func surveyButtonPressed(_ indexPath: IndexPath) {
        delegate?.selectedSurvey(surveys[indexPath.row])
    }
}
