//
//  RevlumDeviceFilterItem.swift
//  
//
//  Created by Filip Varda on 28.06.2023..
//

import UIKit

protocol RevlumDeviceFilterDelegate: AnyObject {
    func filterSelected(type: FilterType)
}

class RevlumDeviceFilterItem: UITableViewCell {
    static let identifier = "RevlumDeviceFilterItem"

    private let titleLabel = UILabel(text: "Device", font: .systemFont(ofSize: 16, weight: .semibold), textColor: .textMainColor)
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    weak var delegate: RevlumDeviceFilterDelegate?

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
    private func setUpViews() {
        selectionStyle = .none
        backgroundColor = .clear
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
            stackView.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -Constants.leftRightOffset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    func configure(with filterButtonTitles: [String]) {
        let buttons = filterButtonTitles.map { title in
            let button = RevlumFilterButton(title: title)
            button.isSelected = false
            button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)

            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 100).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true

            return button
        }
        buttons.forEach { stackView.addArrangedSubview($0) }
    }

    @objc func buttonTapped(sender: RevlumFilterButton) {
        guard let senderTitle = sender.titleLabel?.text,
              let type = FilterType(rawValue: senderTitle),
              let subviews = stackView.arrangedSubviews as? [RevlumFilterButton] else { return }
        subviews.forEach { $0.isSelected = false }
        sender.isSelected = true
        delegate?.filterSelected(type: type)
    }
}

// MARK: - Constants
extension RevlumDeviceFilterItem {
    struct Constants {
        static let leftRightOffset = 16.0
    }
}

