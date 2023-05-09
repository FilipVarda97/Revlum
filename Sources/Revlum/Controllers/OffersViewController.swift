//
//  File.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

final class OffersViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = OffersViewModel()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OfferTableViewCell.self, forCellReuseIdentifier: OfferTableViewCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Implementation
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        viewModel.fetchOffers()
    }

    private func setUpViews() {
        view.addSubviews(tableView)
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        viewModel.delegate = self
    }

    private func setUpConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension OffersViewController: OffersViewModelDelegate {
    func didFetchOffers() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
