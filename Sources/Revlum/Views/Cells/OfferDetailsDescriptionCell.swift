//
//  OfferDetailsDescriptionCell.swift
//  
//
//  Created by Filip Varda on 26.06.2023..
//

import UIKit

class OfferDetailsDescriptionCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "OfferDetailsDescriptionCell"

    private let titleLabel = UILabel(text: "Description", font: .systemFont(ofSize: 17, weight: .bold), textColor: .textMainColor)
    private let revenuLabel = UILabel(font: .systemFont(ofSize: 15, weight: .bold), textColor: .textMainColor)
    private let descriptionLabel = UILabel(font: .systemFont(ofSize: 15, weight: .regular), textColor: .textDescriptionColor, numberOfLines: 0)

    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .textDescriptionColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
        circleView.frame.size = CGSize(width: 12, height: 12)
        circleView.layer.cornerRadius = circleView.frame.height / 2
        
        contentView.addSubviews(titleLabel,
                    revenuLabel,
                    descriptionLabel,
                    circleView)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.leftAnchor)
        ])
    }

    func configure(revenu: String, description: String) {
        revenuLabel.text = revenu
        descriptionLabel.text = description
    }
}
