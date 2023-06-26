//
//  BaseTableViewCell.swift
//  
//
//  Created by Filip Varda on 07.06.2023..
//

import UIKit

enum RevlumCellType {
    case offers
    case surveys

    var imageInset: UIEdgeInsets {
        switch self {
        case .offers:
            return UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 13)
        case .surveys:
            return UIEdgeInsets(top: 21, left: 21, bottom: 21, right: 13)
        }
    }

    var visualDescriptionConteinerHeight: CGFloat {
        switch self {
        case .offers:
            return 31
        case .surveys:
            return 14
        }
    }

    var imageWidth: CGFloat {
        switch self {
        case .offers:
            return 84
        case .surveys:
            return 63
        }
    }

    var visualDescriptionConteinerOffset: CGFloat {
        switch self {
        case .offers:
            return 13
        case .surveys:
            return 9
        }
    }
}

protocol RevlumCellDelegate: AnyObject {
    func buttonPressed(_ selectedIndexPath: IndexPath)
}

class BaseTableViewCell: UITableViewCell {
    let containerView = UIView()
    let visualDescriptionContainerView = UIView()
    let cellImageView = UIImageView()
    let titleLabel = UILabel(text: "", font: .systemFont(ofSize: 15, weight: .semibold))
    let descriptionLabel = UILabel(text: "", font: .systemFont(ofSize: 13))
    let selectionButton = UIButton()
    var indexPath: IndexPath?
    var cellType: RevlumCellType = .offers

    weak var delegate: RevlumCellDelegate?
    
    // MARK: - Init
    init(cellType: RevlumCellType, reuseIdentifier: String) {
        self.cellType = cellType
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    func setUpViews() {
        containerView.backgroundColor = .white
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionButton.addTarget(self, action: #selector(selectionButtonPressed), for: .touchUpInside)

        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true

        titleLabel.textColor = .textMainColor
        descriptionLabel.textColor = .textDescriptionColor

        selectionButton.backgroundColor = .primaryColor
        selectionButton.setTitleColor(.white, for: .normal)
        selectionButton.titleLabel?.font = .systemFont(ofSize: 14)
        selectionButton.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)

        cellImageView.layer.cornerRadius = 4
        cellImageView.clipsToBounds = true

        contentView.addSubview(containerView)
        containerView.addSubviews(cellImageView,
                                  titleLabel,
                                  descriptionLabel,
                                  visualDescriptionContainerView,
                                  selectionButton)
    }

    func setUpConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        visualDescriptionContainerView.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        selectionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: -8),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                                 constant: -10),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                                constant: 10)
        ])
        NSLayoutConstraint.activate([
            cellImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor,
                                                 constant: cellType.imageInset.left),
            cellImageView.topAnchor.constraint(equalTo: containerView.topAnchor,
                                                constant: cellType.imageInset.top),
            cellImageView.bottomAnchor.constraint(equalTo: selectionButton.topAnchor,
                                                   constant: -cellType.imageInset.bottom),
            cellImageView.widthAnchor.constraint(equalToConstant: cellType.imageWidth)
        ])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cellImageView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: cellImageView.rightAnchor,
                                             constant: cellType.imageInset.right),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor,
                                              constant: -11)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor,
                                                    constant: -11)
        ])
        NSLayoutConstraint.activate([
            visualDescriptionContainerView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,
                                                                constant: cellType.visualDescriptionConteinerOffset),
            visualDescriptionContainerView.leftAnchor.constraint(equalTo: cellImageView.rightAnchor,
                                                                 constant: cellType.imageInset.right),
            visualDescriptionContainerView.heightAnchor.constraint(equalToConstant: cellType.visualDescriptionConteinerHeight)
        ])
        NSLayoutConstraint.activate([
            selectionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            selectionButton.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            selectionButton.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            selectionButton.heightAnchor.constraint(equalToConstant: 47)
        ])
    }

    @objc func selectionButtonPressed() {
        guard let selectedIndexPath = indexPath else { return }
        delegate?.buttonPressed(selectedIndexPath)
    }
}
