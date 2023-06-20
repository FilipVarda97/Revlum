# Revlum

A description of this package.j

In this code, my o

import UIKit
import Combine

public final class RevlumViewController: UIViewController {
    // MARK: - Views
    private let brandBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .topBGImage
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let brandLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .revlumLogo
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let dissmissButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let segmentedControl: RevlumSegmentedControl = {
        let control = RevlumSegmentedControl(items: ["Offers", "Surveys"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .large
        spinner.color = .textMainColor
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    private let offersTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OfferTableViewCell.self, forCellReuseIdentifier: OfferTableViewCell.reuseIdentifier)
        tableView.register(SearchOffersTableViewCell.self, forCellReuseIdentifier: SearchOffersTableViewCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .secondaryColor
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let surveysTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SurveyTableViewCell.self, forCellReuseIdentifier: SurveyTableViewCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .secondaryColor
        tableView.allowsSelection = false
        tableView.alpha = 0
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private var filterView: RevlumFilterView?

    // MARK: - Properties
    private let apiKey: String
    private let userId: String
    private var location: String?

    private let mainViewModel = MainViewModel()
    private var offersViewModel = OffersViewModel()
    private var surveysViewModel = SurveysViewModel()

    private let mainInput = PassthroughSubject<MainViewModel.Input, Never>()
    private let offersInput = PassthroughSubject<OffersViewModel.Input, Never>()
    private let surveysInput = PassthroughSubject<SurveysViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    public init(apiKey: String, userId: String) {
        let fontLoader = FontLoader()
        fontLoader.loadFonts()

        self.apiKey = apiKey
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Revlum does not support this initializer")
    }

    // MARK: - Implementation
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setUpConstraints()
        setUpActions()
        bindMain()
        bindOffers()
        mainInput.send(.openSdk)
    }

    private func setupViews() {
        surveysTableView.delegate = surveysViewModel
        surveysTableView.dataSource = surveysViewModel

        offersTableView.delegate = offersViewModel
        offersTableView.dataSource = offersViewModel

        dissmissButton.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        dissmissButton.tintColor = .white

        view.addSubviews(brandBackgroundImageView,
                         brandLogoImageView,
                         dissmissButton,
                         surveysTableView,
                         offersTableView,
                         segmentedControl,
                         spinner)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            brandBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            brandBackgroundImageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            brandBackgroundImageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            brandBackgroundImageView.bottomAnchor.constraint(equalTo: segmentedControl.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            brandLogoImageView.heightAnchor.constraint(equalToConstant: 43),
            brandLogoImageView.widthAnchor.constraint(equalToConstant: 200),
            brandLogoImageView.centerYAnchor.constraint(equalTo: brandBackgroundImageView.centerYAnchor),
            brandLogoImageView.centerXAnchor.constraint(equalTo: brandBackgroundImageView.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            dissmissButton.heightAnchor.constraint(equalToConstant: 40),
            dissmissButton.widthAnchor.constraint(equalToConstant: 40),
            dissmissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            dissmissButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 124),
            segmentedControl.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            segmentedControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            surveysTableView.topAnchor.constraint(equalTo: segmentedControl.centerYAnchor),
            surveysTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            surveysTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            surveysTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            offersTableView.topAnchor.constraint(equalTo: segmentedControl.centerYAnchor),
            offersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            offersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            offersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 50),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setUpActions() {
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        dissmissButton.addTarget(self, action: #selector(dismissPressed), for: .touchUpInside)
    }

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UIView.animate(withDuration: 0.2) {
                self.surveysTableView.alpha = 0
            } completion: { _ in
                self.surveysTableView.isHidden = true
                self.offersTableView.isHidden = false
                UIView.animate(withDuration: 0.2) {
                    self.offersTableView.alpha = 1
                }
            }
        case 1:
            UIView.animate(withDuration: 0.2) {
                self.offersTableView.alpha = 0
            } completion: { _ in
                self.offersTableView.isHidden = true
                self.surveysTableView.isHidden = false
                UIView.animate(withDuration: 0.2) {
                    self.surveysTableView.alpha = 1
                }
            }
        default:
            break
        }
    }

    @objc private func dismissPressed() {
        dismiss(animated: true)
    }

    private func forceEndEditing() {
        view.endEditing(true)
    }
}

// MARK: - OffersViewModel Main Binding
private extension RevlumViewController {
    private func bindMain() {
        mainViewModel.transform(input: mainInput.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .locationFetched(let location):
                    self?.fetchData(location)
                case .locationFetchFailed:
                    self?.handleLocationFetchError()
                }
            }.store(in: &cancellables)
    }

    private func fetchData(_ location: String) {
        surveysInput.send(.loadSurveys(location))
        offersInput.send(.loadOffers(location))
    }

    private func handleLocationFetchError() {
        print("LOCATION FETCH FAILED!")
    }
}

// MARK: - OffersViewModel Offers Binding
private extension RevlumViewController {
    private func bindOffers() {
        offersViewModel.transform(input: offersInput.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .offersLoaded:
                    self?.offersTableView.reloadData()
                case .offersFailedToLoad: break
                case .openOffer(let offer):
                    print(offer.title)
                case .startLoading:
                    self?.spinner.startAnimating()
                case .stopLoading:
                    self?.spinner.stopAnimating()
                case .filterPressed:
                    self?.forceEndEditing()
                    self?.openFilter()
                case .forceEndEditing:
                    self?.forceEndEditing()
                }
            }.store(in: &cancellables)
    }

    private func openFilter() {
        guard self.filterView == nil else { return }

        let filterView = RevlumFilterView()
        filterView.translatesAutoresizingMaskIntoConstraints = false
        filterView.delegate = self
        view.addSubview(filterView)

        NSLayoutConstraint.activate([
            filterView.heightAnchor.constraint(equalToConstant: 290),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 290)
        ])

        self.filterView = filterView

        view.layoutIfNeeded()

        UIView.animate(withDuration: 0.5, animations: {
            filterView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: - OffersViewModel Surveys Binding
private extension RevlumViewController {
    private func bindSurveys() {
        surveysViewModel.transform(input: surveysInput.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .loadedSurveys:
                    self?.surveysTableView.reloadData()
                case .failedToLoadSurveys: break
                case .selectedSurvey(let survey):
                    print(survey.title)
                case .startLoading:
                    self?.spinner.startAnimating()
                case .stopLoading:
                    self?.spinner.stopAnimating()
                }
            }.store(in: &cancellables)
    }
}

extension RevlumViewController: RevlumFilterDelegate {
    func filterSelected(type: FilterType) {}
    func sortSelected(sort: SortType) {}
}


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
        case filterPressed
        case forceEndEditing
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
            cell.configure(with: cellViewModels[indexPath.row], indexPath: indexPath)
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
        if scrollViewOffset.y == scrollView.contentOffset.y.rounded() { return }
        scrollViewOffset = CGPoint(x: 0, y: scrollView.contentOffset.y.rounded())
        output.send(.forceEndEditing)
    }
}

// MARK: - OfferTableViewCellDelegate
extension OffersViewModel: RevlumCellDelegate {
    func buttonPressed(_ selectedIndexPath: IndexPath) {
        output.send(.openOffer(offers[selectedIndexPath.row]))
    }
}

extension OffersViewModel: SearchCellDelegate {
    func filterButtonPressed() {
        output.send(.filterPressed)
    }

    func textFieldTextChanged(_ text: String) {
        print(text)
    }
}


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
        return 169
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
