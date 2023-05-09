//
//  File.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

final class OfferTableViewCell: UITableViewCell {
    static let reuseIdentifier = "OfferTableViewCell"

    private let containerView = UIView()
    private let offerImageView = UIImageView(image: .topBGImage)
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
        contentView.backgroundColor = .clear
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
        containerView.backgroundColor = .bgColor

        titleLabel.textColor = .textMainColor
        descriptionLabel.textColor = .textDescriptionColor

        offerButton.layer.cornerRadius = 10
        offerButton.backgroundColor = .primaryColor
        offerButton.setTitleColor(.white, for: .normal)
        offerButton.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)

        offerImageView.layer.cornerRadius = 5
        offerImageView.clipsToBounds = true

        contentView.addSubview(containerView)
        containerView.addSubviews(offerImageView,
                                titleLabel,
                                descriptionLabel,
                                offerButton)
    }

    private func setUpConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        offerImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        offerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10)
        ])
        NSLayoutConstraint.activate([
            offerImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            offerImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
            offerImageView.widthAnchor.constraint(equalToConstant: 85),
            offerImageView.heightAnchor.constraint(equalToConstant: 85)
        ])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: offerImageView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: offerImageView.rightAnchor, constant: 12),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            offerButton.bottomAnchor.constraint(equalTo: offerImageView.bottomAnchor),
            offerButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10)
        ])
    }

    private func updateCell() {
        guard let offer = offer else { return }
        titleLabel.text = offer.title
        descriptionLabel.text = offer.description
        offerButton.setTitle(offer.revenue, for: .normal)
        guard let imageURL = URL(string: offer.image) else { return }
        RevlumImageLoader.shared.downloadImage(from: imageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.offerImageView.image = image
            }
        }
    }

    public func configure(with offer: Offer) {
        self.offer = offer
    }
}
