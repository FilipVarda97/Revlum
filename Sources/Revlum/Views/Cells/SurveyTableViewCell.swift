//
//  File.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

final class SurveyTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SurveyTableViewCell"

    private let containerView = UIView()
    private let surveyImageView = UIImageView()
    private let titleLabel = UILabel(text: "")
    private let descriptionLabel = UILabel(text: "")
    private let surveyButton = UIButton()

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
        containerView.backgroundColor = .white
        contentView.backgroundColor = .clear
        backgroundColor = .clear

        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true

        titleLabel.textColor = .textMainColor
        descriptionLabel.textColor = .textDescriptionColor

        surveyButton.backgroundColor = .primaryColor
        surveyButton.setTitleColor(.white, for: .normal)
        surveyButton.contentEdgeInsets = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)

        surveyImageView.layer.cornerRadius = 5
        surveyImageView.clipsToBounds = true

        contentView.addSubview(containerView)
        containerView.addSubviews(surveyImageView,
                                  titleLabel,
                                  descriptionLabel,
                                  surveyButton)
    }

    private func setUpConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        surveyImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        surveyButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10)
        ])
        NSLayoutConstraint.activate([
            surveyImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 21),
            surveyImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 21),
            surveyImageView.bottomAnchor.constraint(equalTo: surveyButton.topAnchor, constant: 21),
            surveyImageView.widthAnchor.constraint(equalTo: surveyImageView.heightAnchor)
        ])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: surveyImageView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: surveyImageView.rightAnchor, constant: 13),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -21)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            surveyButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            surveyButton.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            surveyButton.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            surveyButton.heightAnchor.constraint(equalToConstant: 47)
        ])
    }

    public func configure(with viewModel: SurveyCellViewModel) {
        titleLabel.text = viewModel.surveyTitle
        descriptionLabel.text = viewModel.surveyDescription
        surveyButton.setTitle(viewModel.surveyRevenue, for: .normal)

        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    self?.surveyImageView.image = UIImage(data: imageData)
                }
            case .failure:
                print("Error Loading Image")
                break
            }
        }
    }
}
