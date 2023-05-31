//
//  RevlumViewController.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit
import Combine

public final class RevlumViewController: UIViewController {
    // MARK: - Views
    private let brandBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let brandLogoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let dissmissButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        return button
    }()
    private let segmentedControl: RevlumSegmentedControl = {
        let control = RevlumSegmentedControl(items: ["Offers", "Surveys"])
        return control
    }()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .large
        spinner.color = .textMainColor
        return spinner
    }()
    private let offersTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OfferTableViewCell.self, forCellReuseIdentifier: OfferTableViewCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .bgColor
        tableView.allowsSelection = false
        return tableView
    }()
    private let surveysTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SurveyTableViewCell.self, forCellReuseIdentifier: SurveyTableViewCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .bgColor
        tableView.allowsSelection = false
        tableView.alpha = 0
        return tableView
    }()

    // MARK: - Properties
    private let apiKey: String
    private let userId: String
    private var location: String?

    private let mainViewModel = MainViewModel()
    private var offersViewModel = OffersViewModel()
    private var surveysViewModel = SurveysViewModel()

    private var cancellables = Set<AnyCancellable>()
    private let mainInput = PassthroughSubject<MainViewModel.Input, Never>()
    private let offersInput = PassthroughSubject<OffersViewModel.Input, Never>()

    // MARK: - Init
    public init(apiKey: String, userId: String) {
        registerCommonFonts()
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
        surveysViewModel.delegate = self

        surveysTableView.delegate = surveysViewModel
        surveysTableView.dataSource = surveysViewModel

        offersTableView.delegate = offersViewModel
        offersTableView.dataSource = offersViewModel

        dissmissButton.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        dissmissButton.tintColor = .white
        brandBackgroundImageView.image = .topBGImage
        brandBackgroundImageView.contentMode = .scaleToFill
        brandLogoImageView.image = .revlumLogo
        brandLogoImageView.contentMode = .scaleAspectFit

        brandBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        brandLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        dissmissButton.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        surveysTableView.translatesAutoresizingMaskIntoConstraints = false
        offersTableView.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false

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
                UIView.animate(withDuration: 0.2) {
                    self.offersTableView.alpha = 1
                }
            }
        case 1:
            UIView.animate(withDuration: 0.2) {
                self.offersTableView.alpha = 0
            } completion: { _ in
                self.offersTableView.isHidden = true
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
}

// MARK: - OffersViewModel Main Binding
private extension RevlumViewController {
    private func bindMain() {
        mainViewModel.transform(input: mainInput.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .locationFetched(let location):
                    self?.offersInput.send(.loadOffers(location))
                case .locationFetchFailed:
                    self?.handleLocationFetchError()
                }
            }.store(in: &cancellables)
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
                case .openOffer(let offer): break
                case .startLoading:
                    self?.spinner.startAnimating()
                case .stopLoading:
                    self?.spinner.stopAnimating()
                }
            }.store(in: &cancellables)
    }
}

// MARK: - SurveysViewModelDelegate
extension RevlumViewController: SurveysViewModelDelegate {
    func didStartLoadingSurveys() {
        spinner.isHidden = false
        spinner.startAnimating()
    }

    func didFailToLoadSurveys() {
        DispatchQueue.main.async { [weak self] in
            print("Error: Failed to load Surveys")
            self?.spinner.stopAnimating()
        }
    }

    func didLoadSurveys() {
        
    }

    func selectedSurvey(_ survey: Survey) {
        print(survey.title)
    }
}
