//
//  RevlumNewUsersView.swift
//  
//
//  Created by Filip Varda on 27.06.2023..
//

import UIKit

class RevlumNewUsersView: UIView {
    private let label = UILabel(text: "New Users", font: .systemFont(ofSize: 12, weight: .semibold), textColor: .newUsersColor, textAlignment: .center)

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Implementation
    private func setupViews() {
        addSubview(label)
        backgroundColor = .newUsersOpacityColor
        translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
