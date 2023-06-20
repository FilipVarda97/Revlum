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
    private let surveysInput = PassthroughSubject<SurveysViewModel.Input, Never>()

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
                    self?.offersInput.send(.loadOffers(location))
                    self?.surveysInput.send(.loadSurveys(location))
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
        let filterVC = RevlumFilterViewController()
        filterVC.modalPresentationStyle = .custom
        filterVC.transitioningDelegate = self
        present(filterVC, animated: true, completion: nil)
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

// MARK: - UIViewControllerTransitioningDelegate
extension RevlumViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if presented is RevlumFilterViewController {
            return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
        }
        return nil
    }
}
