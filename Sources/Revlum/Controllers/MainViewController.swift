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

    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Offers", "Surveys"])
        control.selectedSegmentIndex = 0
        control.addTarget(MainViewController.self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        return control
    }()
    private lazy var childViewController1: OffersViewController = {
        let viewController = OffersViewController()
        viewController.view.backgroundColor = .systemRed
        return viewController
    }()
    private lazy var childViewController2: SurveyViewController = {
        let viewController = SurveyViewController()
        viewController.view.backgroundColor = .systemBlue
        return viewController
    }()
    private let containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Init
    init(apiKey: String, userId: String) {
        self.apiKey = apiKey
        self.userId = userId
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("Revlum does not support this initializer")
    }

    // MARK: - Implementation
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        add(childViewController: childViewController1)
    }
    
    private func setupViews() {
        view.addSubviews(segmentedControl, containerView)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            switchTo(childViewController: childViewController1)
        case 1:
            switchTo(childViewController: childViewController2)
        default:
            break
        }
    }

    private func add(childViewController: UIViewController) {
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
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
