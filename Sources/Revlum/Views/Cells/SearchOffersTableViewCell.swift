//
//  SearchOffersTableViewCell.swift
//  
//
//  Created by Filip Varda on 08.06.2023..
//

import UIKit

protocol SearchCellDelegate: AnyObject {
    func filterButtonPressed()
}

class SearchOffersTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SearchOffersTableViewCell"

    private let searchBar = UISearchBar()
    private let filterButton = IconButton()
    weak var delegate: SearchCellDelegate?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    func setUpViews() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear

        searchBar.backgroundColor = .white
        searchBar.layer.cornerRadius = 5
        searchBar.placeholder = "Search offers..."

        filterButton.setImage(.filterIcon, for: .normal)
        filterButton.setTitle("Filter", for: .normal)
        filterButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        filterButton.contentHorizontalAlignment = .left
        filterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        filterButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)

        contentView.addSubviews(searchBar,
                                filterButton)
    }

    func setUpConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            searchBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            filterButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            filterButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            filterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            filterButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    @objc func filterButtonPressed() {
        delegate?.filterButtonPressed()
    }
}
