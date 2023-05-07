//
//  File.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

final class OffersViewController: UIViewController {
    // MARK: - Properties
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OfferTableViewCell.self, forCellReuseIdentifier: OfferTableViewCell.reuseIdentifier)
        return tableView
    }()

    // MARK: - Implementation
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension OffersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OfferTableViewCell.reuseIdentifier) as? OfferTableViewCell else { return UITableViewCell() }
        cell.configure(with: "this is Offer - \(indexPath.row)")
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
