//
//  RevlumOfferDetailsViewController.swift
//  
//
//  Created by Filip Varda on 26.06.2023..
//

import UIKit

class RevlumOfferDetailsViewController: UIViewController {
    private let titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(OfferTableViewCell.self, forCellReuseIdentifier: OfferTableViewCell.reuseIdentifier)
        tableView.register(OfferDetailsDescriptionCell.self, forCellReuseIdentifier: OfferDetailsDescriptionCell.identifier)
        tableView.register(OfferDetailsTermsCell.self, forCellReuseIdentifier: OfferDetailsTermsCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
        tableView.delegate = self
        tableView.dataSource = self

        view.backgroundColor = .white
        titleContainerView.backgroundColor = .white
        titleLabel.text = offer.title
        titleLabel.textColor = .textMainColor
        titleLabel.font = .systemFont(ofSize: 19, weight: .bold)

        dissmissButton.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        dissmissButton.tintColor = .textMainColor
        dissmissButton.addTarget(self, action: #selector(dismissPressed), for: .touchUpInside)

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
            titleLabel.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 38),
            titleLabel.rightAnchor.constraint(equalTo: dissmissButton.leftAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            dissmissButton.heightAnchor.constraint(equalToConstant: 40),
            dissmissButton.widthAnchor.constraint(equalToConstant: 40),
            dissmissButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            dissmissButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -18)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 38),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -38),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func dismissPressed() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RevlumOfferDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OfferTableViewCell.reuseIdentifier) as? OfferTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: .init(offer: offer), indexPath: indexPath)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OfferDetailsDescriptionCell.identifier) as? OfferDetailsDescriptionCell else {
                return UITableViewCell()
            }
            cell.configure(revenu: offer.revenue, description: offer.description)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OfferDetailsTermsCell.identifier) as? OfferDetailsTermsCell else {
                return UITableViewCell()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 169
        case 1:
            return 169
        case 2:
            return 169
        default:
            return 169
        }
    }
}
