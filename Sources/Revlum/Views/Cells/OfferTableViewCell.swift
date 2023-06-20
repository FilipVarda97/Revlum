//
//  File.swift
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
        return stackView
    }()

    private var viewModel: OfferCellViewModel?

    override func setUpViews() {
        super.setUpViews()
    }

    public func configure(with viewModel: OfferCellViewModel, indexPath: IndexPath) {
        self.viewModel = viewModel
        self.indexPath = indexPath
        titleLabel.text = viewModel.offerTitle
        descriptionLabel.text = viewModel.offerDescription
        selectionButton.setTitle("+" + viewModel.offerRevenue, for: .normal)
        setUpIcons()

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
}
