//
//  File.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

final class OfferTableViewCell: UITableViewCell {
    static let reuseIdentifier = "OfferTableViewCell"

    private let offerImageView = UIImageView()
    private let titleLabel = UILabel(text: "")
    private let descriptionLabel = UILabel(text: "")
    private let platforms: [UIImage] = [UIImage]()
    private let offerButton = UIButton()

    private var offer: Offer? {
        didSet {
            updateCell()
        }
    }

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
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        contentView.backgroundColor = .bgColor

        contentView.addSubviews(offerImageView,
                                titleLabel,
                                descriptionLabel,
                                offerButton)
    }

    private func setUpConstraints() {
        offerImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        offerButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            offerImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            offerImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            offerImageView.widthAnchor.constraint(equalToConstant: 85),
            offerImageView.heightAnchor.constraint(equalToConstant: 85)
        ])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: offerImageView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: offerImageView.rightAnchor, constant: 12)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 6),
            descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor)
        ])
        NSLayoutConstraint.activate([
            offerButton.bottomAnchor.constraint(equalTo: offerImageView.bottomAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10)
        ])
    }

    private func updateCell() {
        titleLabel.text = offer?.title
        descriptionLabel.text = offer?.description
        offerButton.setTitle("+ \(String(describing: offer?.revenue))", for: .normal)
    }

    public func configure(with offer: Offer) {
        self.offer = offer
    }
}
