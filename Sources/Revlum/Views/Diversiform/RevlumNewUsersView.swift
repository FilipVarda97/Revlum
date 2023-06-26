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
        layer.cornerRadius = frame.height / 2
        translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: label.intrinsicContentSize.width + 18),
            widthAnchor.constraint(equalToConstant: label.intrinsicContentSize.height + 10),

            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
