//
//  RevlumFilterButton.swift
//  
//
//  Created by Filip Varda on 20.06.2023..
//

import UIKit

class RevlumFilterButton: UIButton {
    private var title: String

    // MARK: - Init
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        isEnabled = true
        updateAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Implementation
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 2
        layer.cornerRadius = bounds.height / 2
    }

    private func updateAppearance() {
        if isSelected {
            setTitleColor(.primaryColor, for: .normal)
            layer.borderColor = UIColor.primaryColor.cgColor
            titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        } else {
            setTitleColor(.textMainColor, for: .normal)
            layer.borderColor = UIColor.separatorColor.cgColor
            titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }
}
