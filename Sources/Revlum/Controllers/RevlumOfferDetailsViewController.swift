//
//  RevlumOfferDetailsViewController.swift
//  
//
//  Created by Filip Varda on 26.06.2023..
//

import UIKit

class RevlumOfferDetailsViewController: UIViewController {
    private let titleContainerView = UIView()
    private let titleLabel = UILabel()

    private let dissmissButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.register(OfferTableViewCell.self, forCellReuseIdentifier: OfferTableViewCell.reuseIdentifier)
        return tableView
    }()

    private let offer: Offer

    init(offer: Offer) {
        self.offer = offer
        super.init(nibName: nil, bundle: nil)
        setUpViews()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Revlum does not support this initializer")
    }
}

// MARK: - Implementation
extension RevlumOfferDetailsViewController {
    private func setUpViews() {
        view.backgroundColor = .white
        titleContainerView.backgroundColor = .white
        titleLabel.text = offer.title
        titleLabel.font = .systemFont(ofSize: 19, weight: .bold)

        dissmissButton.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        dissmissButton.tintColor = .white

        view.addSubviews(titleContainerView,
                        tableView)

        titleContainerView.addSubviews(titleLabel,
                                       dissmissButton)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            titleContainerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            titleContainerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            titleContainerView.heightAnchor.constraint(equalToConstant: 67)
        ])
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 38),
            titleLabel.rightAnchor.constraint(equalTo: dissmissButton.leftAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            dissmissButton.heightAnchor.constraint(equalToConstant: 40),
            dissmissButton.widthAnchor.constraint(equalToConstant: 40),
            dissmissButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            dissmissButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -18)
        ])
    }
}
