//
//  RevlumFilterView.swift
//  
//
//  Created by Filip Varda on 20.06.2023..
//

import UIKit

protocol RevlumFilterDelegate: AnyObject {
    func closeFilterView()
    func filterSelected(filter: FilterType)
    func sortSelected(sort: SortType)
}

enum FilterType {
    case ios
    case web
}

enum SortType {
    case descending
    case ascending
}

class RevlumFilterView: UIView {
    // MARK: - Properties
    private let titleContainerView = UIView()
    private let titleLabel = UILabel(text: "Sort by", font: .systemFont(ofSize: 19, weight: .semibold), textColor: .textMainColor, textAlignment: .center)
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(RevlumSortItem.self, forCellReuseIdentifier: RevlumSortItem.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let iOSButton = RevlumFilterButton(title: "iOS")
    private let webButton = RevlumFilterButton(title: "Web")
    private let dissmissButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    weak var delegate: RevlumFilterDelegate?

    // MARK: - Init
    init(filterType: FilterType = .ios, sortType: SortType = .descending) {
        super.init(frame: .zero)
        setUpViews()
        setUpConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("Revlum does not support this initializer")
    }

    // MARK: - Implementation
    private func setUpViews() {
        backgroundColor = .white

        tableView.delegate = self
        tableView.dataSource = self

        dissmissButton.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        dissmissButton.tintColor = .textMainColor
        dissmissButton.addTarget(self, action: #selector(closeFilter), for: .touchUpInside)

        iOSButton.setTitle("iOS", for: .normal)
        webButton.setTitle("Web", for: .normal)

        iOSButton.addTarget(self, action: #selector(iosButtonTapped), for: .touchUpInside)
        webButton.addTarget(self, action: #selector(webButtonTapped), for: .touchUpInside)

        titleContainerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dissmissButton.translatesAutoresizingMaskIntoConstraints = false
        iOSButton.translatesAutoresizingMaskIntoConstraints = false
        webButton.translatesAutoresizingMaskIntoConstraints = false

        addSubviews(titleContainerView,
                    iOSButton,
                    webButton)

        titleContainerView.addSubviews(titleLabel,
                                       dissmissButton)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleContainerView.topAnchor.constraint(equalTo: topAnchor),
            titleContainerView.leftAnchor.constraint(equalTo: leftAnchor),
            titleContainerView.rightAnchor.constraint(equalTo: rightAnchor),
            titleContainerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: titleContainerView.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            dissmissButton.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),
            dissmissButton.rightAnchor.constraint(equalTo: titleContainerView.rightAnchor, constant: -18),
            dissmissButton.heightAnchor.constraint(equalToConstant: 40),
            dissmissButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            iOSButton.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            iOSButton.widthAnchor.constraint(equalToConstant: 100),
            iOSButton.heightAnchor.constraint(equalToConstant: 40),
            iOSButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        NSLayoutConstraint.activate([
            webButton.topAnchor.constraint(equalTo: iOSButton.bottomAnchor, constant: 20),
            webButton.widthAnchor.constraint(equalToConstant: 100),
            webButton.heightAnchor.constraint(equalToConstant: 40),
            webButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    @objc private func iosButtonTapped() {
        delegate?.filterSelected(filter: .ios)
    }

    @objc private func webButtonTapped() {
        delegate?.filterSelected(filter: .web)
    }

    @objc func closeFilter() {
        delegate?.closeFilterView()
    }
}

// MARK: TableView Delegate/Data Source
extension RevlumFilterView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RevlumSortItem.identifier) as? RevlumSortItem else {
            return UITableViewCell()
        }
        switch indexPath.row {
        case 0:
            cell.configure(title: "High to Low")
        case 1:
            cell.configure(title: "Low to High")
        default: break
        }
        return cell
    }
}
