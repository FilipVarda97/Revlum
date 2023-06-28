//
//  RevlumDeviceFilterItem.swift
//  
//
//  Created by Filip Varda on 28.06.2023..
//

import UIKit

class RevlumDeviceFilterItem: UITableViewCell {
    static let identifier = "RevlumDeviceFilterItem"

    private let titleLabel = UILabel(text: "Device", font: .systemFont(ofSize: 12), textColor: .textMainColor)
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        backgroundColor = .clear
        setUpViews()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    private func setUpViews() {
        selectionStyle = .none
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubviews(titleLabel, stackView)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.leftRightOffset),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.leftRightOffset)
        ])
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.leftRightOffset),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.leftRightOffset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    func configure(with filterButtonTitles: [String]) {
        let buttons = filterButtonTitles.map { title in
            let button = RevlumFilterButton(title: title)
            button.isSelected = false
            return button
        }
        buttons.forEach { stackView.addArrangedSubview($0) }
    }
}

// MARK: - Constants
extension RevlumDeviceFilterItem {
    struct Constants {
        static let leftRightOffset = 16.0
    }
}

