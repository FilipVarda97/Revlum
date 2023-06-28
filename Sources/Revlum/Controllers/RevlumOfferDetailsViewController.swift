//
//  RevlumOfferDetailsViewController.swift
//  
//
//  Created by Filip Varda on 26.06.2023..
//

import UIKit

protocol RevlumDetailsViewDelegate: AnyObject {
    func openInSafari(urlToOpen: String)
}

class RevlumOfferDetailsViewController: UIViewController {
    private let titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
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
    weak var delegate: RevlumDetailsViewDelegate?

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
        tableView.estimatedRowHeight = 100

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
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 58),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -58)
        ])
        NSLayoutConstraint.activate([
            dissmissButton.heightAnchor.constraint(equalToConstant: 40),
            dissmissButton.widthAnchor.constraint(equalToConstant: 40),
            dissmissButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            dissmissButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -18)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func dismissPressed() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RevlumOfferDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OfferTableViewCell.reuseIdentifier) as? OfferTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: .init(offer: offer), indexPath: indexPath, isDetail: true)
            cell.delegate = self
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
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 30
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return UITableView.automaticDimension
        default:
            return 169
        }
    }
}

extension RevlumOfferDetailsViewController: RevlumCellDelegate {
    func buttonPressed(_ selectedIndexPath: IndexPath) {
        delegate?.openInSafari(urlToOpen: offer.url)
    }
}
