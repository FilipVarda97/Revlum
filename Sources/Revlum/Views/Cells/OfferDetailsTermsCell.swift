//
//  OfferDetailsTermsCell.swift
//  
//
//  Created by Filip Varda on 26.06.2023..
//

import UIKit

extension OfferDetailsTermsCell {
    static let text = "Using a VPN/Proxy is prohibited.\nUsing an emulator of any kind is\nprohibited.\nYou must start and complete the offer\nfrom the same device and location./nYou must be a new user."
}

class OfferDetailsTermsCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "OfferDetailsTermsCell"

    private let titleLabel = UILabel(text: "Eligibility Terms", font: .systemFont(ofSize: 17, weight: .bold), textColor: .textMainColor)
    private let descriptionLabel = UILabel(text: OfferDetailsTermsCell.text, font: .systemFont(ofSize: 15, weight: .regular), textColor: .textDescriptionColor, numberOfLines: 0)

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
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubviews(titleLabel,
                                descriptionLabel)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.leftAnchor)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 34),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.leftAnchor)
        ])
    }
}

