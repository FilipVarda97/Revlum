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
    private let lineView: UIView = {
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
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        revenuLabel.translatesAutoresizingMaskIntoConstraints = false

        circleView.frame.size = CGSize(width: 12, height: 12)
        circleView.layer.cornerRadius = circleView.frame.height / 2
        
        contentView.addSubviews(titleLabel,
                                revenuLabel,
                                descriptionLabel,
                                circleView,
                                lineView)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 38),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -38)
        ])
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            circleView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            circleView.heightAnchor.constraint(equalToConstant: 12),
            circleView.widthAnchor.constraint(equalToConstant: 12)
            
        ])
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: -3),
            lineView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 1),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        NSLayoutConstraint.activate([
            revenuLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            revenuLabel.leftAnchor.constraint(equalTo: circleView.rightAnchor, constant: 30),
            revenuLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: revenuLabel.bottomAnchor, constant: 20),
            descriptionLabel.leftAnchor.constraint(equalTo: circleView.rightAnchor, constant: 30),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    func configure(revenu: String, description: String) {
        revenuLabel.text = "+ " + revenu
        descriptionLabel.text = description
    }
}
