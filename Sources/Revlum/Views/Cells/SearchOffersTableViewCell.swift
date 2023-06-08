//
//  SearchOffersTableViewCell.swift
//  
//
//  Created by Filip Varda on 08.06.2023..
//

import UIKit

protocol SearchCellDelegate: AnyObject {
    func filterButtonPressed()
    func textFieldTextChanged(_ text: String)
}

class SearchOffersTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SearchOffersTableViewCell"

    private var searchTextField = RevlumSearchBarTextField(textInset: UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 17))
    private let filterButton = RevlumIconButton()
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
        
        searchTextField.backgroundColor = .white
        searchTextField.layer.cornerRadius = 5
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search offers...",
                                                                   attributes: [.foregroundColor: UIColor.darkGray])
        searchTextField.borderStyle = .none
        searchTextField.textColor = .black
        searchTextField.delegate = self

        filterButton.setImage(.filterIcon, for: .normal)
        filterButton.setTitle("Filter", for: .normal)
        filterButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        filterButton.contentHorizontalAlignment = .left
        filterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)

        contentView.addSubviews(searchTextField,
                                filterButton)
    }

    func setUpConstraints() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 11),
            searchTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            searchTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            searchTextField.rightAnchor.constraint(equalTo: filterButton.leftAnchor, constant: -16),
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

// MARK: - UITextFieldDelegate
extension SearchOffersTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Begin")
    }

    func textFieldTextChanged(_ text: String) {
        delegate?.textFieldTextChanged(text)
    }
}
