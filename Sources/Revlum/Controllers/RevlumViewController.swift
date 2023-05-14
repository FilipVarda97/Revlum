//
//  RevlumViewController.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

public final class RevlumViewController: UIViewController {
    // MARK: - Properties
    private let apiKey: String
    private let userId: String

    // MARK: Views
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
        spinner.style = .medium
        return spinner
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OfferTableViewCell.self, forCellReuseIdentifier: OfferTableViewCell.reuseIdentifier)
        tableView.register(SurveyTableViewCell.self, forCellReuseIdentifier: SurveyTableViewCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .secondaryColor
        return tableView
    }()

    private var offersViewModel = OffersViewModel()
    private var surveysViewModel = SurveysViewModel()

    // MARK: - Init
    public init(apiKey: String, userId: String) {
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
    }
    
    private func setupViews() {
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        dissmissButton.addTarget(self, action: #selector(dismissPressed), for: .touchUpInside)

        dissmissButton.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        dissmissButton.tintColor = .white
        brandBackgroundImageView.image = .topBGImage
        brandBackgroundImageView.contentMode = .scaleToFill
        brandLogoImageView.image = .revlumLogo
        brandLogoImageView.contentMode = .scaleAspectFit

        tableView.delegate = offersViewModel
        tableView.dataSource = offersViewModel
        offersViewModel.loadOffers()
        spinner.startAnimating()
        offersViewModel.delegate = self
        surveysViewModel.delegate = self
        

        brandBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        brandLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        dissmissButton.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false

        view.addSubviews(brandBackgroundImageView,
                         brandLogoImageView,
                         dissmissButton,
                         tableView,
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
            tableView.topAnchor.constraint(equalTo: segmentedControl.centerYAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 50),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        guard let type = TransitionType(rawValue: sender.selectedSegmentIndex) else { return }
        let transition = transition(type: type)

        switch sender.selectedSegmentIndex {
        case 0:
            tableView.delegate = offersViewModel
            tableView.dataSource = offersViewModel
            offersViewModel.loadOffers()
        case 1:
            tableView.delegate = surveysViewModel
            tableView.dataSource = surveysViewModel
            surveysViewModel.loadSurveys()
        default:
            break
        }

        tableView.layer.add(transition, forKey: RevlumViewController.tableViewReloadDataAnimationKey)
        tableView.reloadData()
    }

    @objc private func dismissPressed() {
        dismiss(animated: true)
    }
}

// MARK: - OffersViewModelDelegate
extension RevlumViewController: OffersViewModelDelegate {
    func didLoadOffers() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            guard let type = TransitionType(rawValue: weakSelf.segmentedControl.selectedSegmentIndex) else { return }
            let transition = weakSelf.transition(type: type)
            weakSelf.spinner.stopAnimating()
            weakSelf.tableView.layer.add(transition, forKey: RevlumViewController.tableViewReloadDataAnimationKey)
            weakSelf.tableView.reloadData()
        }
    }
}

// MARK: - SurveysViewModelDelegate
extension RevlumViewController: SurveysViewModelDelegate {
    func didLoadSurveys() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            guard let type = TransitionType(rawValue: weakSelf.segmentedControl.selectedSegmentIndex) else { return }
            let transition = weakSelf.transition(type: type)
            weakSelf.spinner.stopAnimating()
            weakSelf.tableView.layer.add(transition, forKey: RevlumViewController.tableViewReloadDataAnimationKey)
            weakSelf.tableView.reloadData()
        }
    }
}

// MARK: - Transition animation
extension RevlumViewController {
    enum TransitionType: Int {
        case offer = 0
        case survey = 1
    }

    static let tableViewReloadDataAnimationKey = "UITableViewReloadDataAnimationKey"

    private func transition(type: TransitionType) -> CATransition {
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        transition.fillMode = CAMediaTimingFillMode.forwards
        transition.duration = 0.5

        switch type {
        case .offer:
            transition.subtype = CATransitionSubtype.fromLeft
        case .survey:
            transition.subtype = CATransitionSubtype.fromRight
        }

        return transition
    }
}
