//
//  SurveyViewController.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

final class SurveyViewController: UIViewController {
    // MARK: - Properties
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SurveyTableViewCell.self, forCellReuseIdentifier: SurveyTableViewCell.reuseIdentifier)
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
extension SurveyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SurveyTableViewCell.reuseIdentifier) as? SurveyTableViewCell else { return UITableViewCell() }
        cell.configure(with: "this is Survey - \(indexPath.row)")
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
