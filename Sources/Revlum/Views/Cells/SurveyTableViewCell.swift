//
//  File.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

final class SurveyTableViewCell: BaseTableViewCell {
    static let reuseIdentifier = "SurveyTableViewCell"
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var viewModel: SurveyCellViewModel?
    
    override func setUpViews() {
        super.setUpViews()
    }
    
    public func configure(with viewModel: SurveyCellViewModel, indexPath: IndexPath) {
        self.viewModel = viewModel
        self.indexPath = indexPath
        titleLabel.text = viewModel.surveyTitle
        descriptionLabel.text = viewModel.surveyDescription
        selectionButton.setTitle("+" + viewModel.surveyRevenue, for: .normal)
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
        if stackView.arrangedSubviews.count > 0 { return }
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: cellImageView.rightAnchor, constant: 13),
            stackView.bottomAnchor.constraint(equalTo: selectionButton.topAnchor, constant: -25),
            stackView.heightAnchor.constraint(equalToConstant: 14)
        ])
        stackView.addArrangedSubview(UIImageView(image: .starIcon))
        stackView.addArrangedSubview(UIImageView(image: .starIcon))
        stackView.addArrangedSubview(UIImageView(image: .starIcon))
        stackView.addArrangedSubview(UIImageView(image: .starIcon))
        stackView.addArrangedSubview(UIImageView(image: .starIcon))
    }
}
