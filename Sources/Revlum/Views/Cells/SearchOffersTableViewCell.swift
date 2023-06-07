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
        searchBar.barStyle = .default
        searchBar.layer.cornerRadius = 5
        searchBar.placeholder = "Search offers..."
        searchBar.searchTextField.backgroundColor = .white

        filterButton.setImage(.filterIcon, for: .normal)
        filterButton.setTitle("Filter", for: .normal)
        filterButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        filterButton.contentHorizontalAlignment = .left
        filterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2)

        contentView.addSubviews(searchBar,
                                filterButton)
    }

    func setUpConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 11),
            searchBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            searchBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            searchBar.rightAnchor.constraint(equalTo: filterButton.leftAnchor, constant: 4),
        ])
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            filterButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -11),
            filterButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    @objc func filterButtonPressed() {
        delegate?.filterButtonPressed()
    }
}
