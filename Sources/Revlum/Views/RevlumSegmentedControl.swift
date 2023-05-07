//
//  RevlumSegmentedControl.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

class RevlumSegmentedControl: UISegmentedControl {
    // MARK: - Init
    override init(items: [Any]?) {
        super.init(items: items)
        setupControl()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupControl()
    }

    // MARK: - Implementation
    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        return CGSize(width: originalSize.width, height: 65)
    }

    private func setupControl() {
        selectedSegmentIndex = 0
        backgroundColor = .white
        setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        setTitleTextAttributes([.foregroundColor: UIColor.black,
                                .underlineStyle: NSUnderlineStyle.single.rawValue,
                                .underlineColor: UIColor.blue], for: .selected)
        
        if let backgroundView = subviews.first {
            backgroundView.layer.cornerRadius = 15
            backgroundView.clipsToBounds = true
        }
    }
}
