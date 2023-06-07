//
//  File.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

final class OfferTableViewCell: BaseTableViewCell {
    static let reuseIdentifier = "OfferTableViewCell"
    private var viewModel: OffersViewModel?

    override func setUpViews() {
        super.setUpViews()
    }

    public func configure(with viewModel: OfferCellViewModel, indexPath: IndexPath) {
        self.indexPath = indexPath
        titleLabel.text = viewModel.offerTitle
        descriptionLabel.text = viewModel.offerDescription
        selectionButton.setTitle("+" + viewModel.offerRevenue, for: .normal)

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
}
