//
//  RevlumSortItem.swift
//  
//
//  Created by Filip Varda on 28.06.2023..
//

import UIKit

class RevlumSortItem: UITableViewCell {
    static let identifier = "RevlumSortItem"

    private let titleLabel = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .textMainColor)
    private let checkImageView = UIImageView()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override var isSelected: Bool {
        didSet {
            updateViews()
        }
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        setUpViews()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Implementation
    private func setUpViews() {
        selectionStyle = .none
        checkImageView.image = .checkIcon
        checkImageView.contentMode = .scaleToFill

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        checkImageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubviews(titleLabel, checkImageView, separatorView)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.leftRightOffset),
            titleLabel.rightAnchor.constraint(equalTo: checkImageView.leftAnchor, constant: -Constants.leftRightOffset)
        ])
        NSLayoutConstraint.activate([
            checkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.leftRightOffset),
            checkImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            checkImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize)
        ])
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.leftRightOffset),
            separatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.leftRightOffset),
            separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorHeight)
        ])
    }

    private func updateViews() {
        titleLabel.font = isSelected ? .systemFont(ofSize: 16, weight: .semibold) : .systemFont(ofSize: 16, weight: .regular)
        checkImageView.isHidden = !isSelected
        backgroundColor = isSelected ? .selectedSortBgColor : .clear
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}

// MARK: - Constants
extension RevlumSortItem {
    struct Constants {
        static let leftRightOffset = 16.0
        static let imageSize = 20.0
        static let separatorHeight = 1.0
    }
}
