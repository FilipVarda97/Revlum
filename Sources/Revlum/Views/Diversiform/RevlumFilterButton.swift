//
//  RevlumFilterButton.swift
//  
//
//  Created by Filip Varda on 20.06.2023..
//

import UIKit

class RevlumFilterButton: UIButton {
    private var title: String

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        self.layer.borderWidth = 1
        updateAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    private func updateAppearance() {
        if isSelected {
            self.setTitleColor(.blue, for: .normal)
            self.layer.borderColor = UIColor.blue.cgColor
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
        } else {
            self.setTitleColor(.gray, for: .normal)
            self.layer.borderColor = UIColor.gray.cgColor
            self.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        }
    }
}
