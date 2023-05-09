//
//  File.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

public final class MainViewController: UIViewController {
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
    private let childControllersContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    private let segmentedControl: RevlumSegmentedControl = {
        let control = RevlumSegmentedControl(items: ["Offers", "Surveys"])
        return control
    }()

    // MARK: Child Controllers
    private lazy var offersViewController: OffersViewController = {
        let viewController = OffersViewController()
        return viewController
    }()
    private lazy var surveyViewController: SurveyViewController = {
        let viewController = SurveyViewController()
        return viewController
    }()

    // MARK: - Init
    public init(apiKey: String, userId: String) {
        self.apiKey = apiKey
        self.userId = userId
        RevlumUserDefaultsService.setValue(apiKey, for: .apiKey)
        RevlumUserDefaultsService.setValue(userId, for: .userId)
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

        brandBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        brandLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        dissmissButton.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        childControllersContainerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubviews(brandBackgroundImageView,
                         brandLogoImageView,
                         dissmissButton,
                         childControllersContainerView,
                         segmentedControl)

        dissmissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        brandBackgroundImageView.image = .topBGImage
        brandBackgroundImageView.contentMode = .scaleToFill
        brandLogoImageView.image = .revlumLogo
        brandLogoImageView.contentMode = .scaleAspectFit

        add(childViewController: offersViewController)
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
            dissmissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            dissmissButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 124),
            segmentedControl.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            segmentedControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            childControllersContainerView.topAnchor.constraint(equalTo: segmentedControl.centerYAnchor),
            childControllersContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childControllersContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childControllersContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            switchTo(childViewController: offersViewController)
        case 1:
            switchTo(childViewController: surveyViewController)
        default:
            break
        }
    }

    @objc private func dismissPressed() {
        dismiss(animated: true)
    }

    private func add(childViewController: UIViewController) {
        addChild(childViewController)
        childControllersContainerView.addSubview(childViewController.view)
        childViewController.view.frame = childControllersContainerView.bounds
        childViewController.didMove(toParent: self)
    }

    private func remove(childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }

    private func switchTo(childViewController: UIViewController) {
        let currentChild = children.first
        remove(childViewController: currentChild!)
        add(childViewController: childViewController)
    }
}
