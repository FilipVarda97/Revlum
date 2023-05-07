//
//  File.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

final class OfferTableViewCell: UITableViewCell {
    static let reuseIdentifier = "OfferTableViewCell"

    private let titleLabel = UILabel(text: "")
    private let descriptionLabel = UILabel(text: "")

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
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.backgroundColor = .clear
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.red.cgColor
        contentView.addSubview(titleLabel)
    }

    private func setUpConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }

    public func configure(with offer: String?) {
        titleLabel.text = offer ?? "-"
    }
}
