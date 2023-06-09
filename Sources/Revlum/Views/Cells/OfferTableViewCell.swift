//
//  OfferTableViewCell.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

final class OfferTableViewCell: BaseTableViewCell {
    static let reuseIdentifier = "OfferTableViewCell"
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let newUsersView = RevlumNewUsersView()

    private var viewModel: OfferCellViewModel?

    override func setUpViews() {
        super.setUpViews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        selectionButton.setAttributedTitle(nil, for: .normal)
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        newUsersView.removeFromSuperview()
        viewModel = nil
    }

    public func configure(with viewModel: OfferCellViewModel, indexPath: IndexPath, isDetail: Bool = false) {
        if isDetail {
            leftContainerConstraint?.constant = 38
            rightContainerConstraint?.constant = -38
            selectionButton.layer.cornerRadius = 5
            layoutIfNeeded()
        }
        self.viewModel = viewModel
        self.indexPath = indexPath
        titleLabel.text = viewModel.offerTitle
        descriptionLabel.text = viewModel.offerDescription
        selectionButton.setAttributedTitle(viewModel.offerRevenue, for: .normal)
        setUpIcons()
        addNewUsersView()

        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    self?.cellImageView.image = UIImage(data: imageData)
                }
            case .failure:
                print("Error Loading Image")
                break
            }
        }
    }

    private func setUpIcons() {
        guard let viewModel = viewModel else { return }
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: cellImageView.rightAnchor, constant: 13),
            stackView.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 34)
        ])

        switch viewModel.offerPlatform {
        case .ios:
            stackView.addArrangedSubview(UIImageView(image: .iosIcon))
        case .desktop:
            stackView.addArrangedSubview(UIImageView(image: .desktopIcon))
        case .all:
            stackView.addArrangedSubview(UIImageView(image: .iosIcon))
            stackView.addArrangedSubview(UIImageView(image: .desktopIcon))
        }
    }

    private func addNewUsersView() {
        contentView.addSubview(newUsersView)
        NSLayoutConstraint.activate([
            newUsersView.leftAnchor.constraint(equalTo: stackView.rightAnchor, constant: 5),
            newUsersView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
        ])
    }
}
