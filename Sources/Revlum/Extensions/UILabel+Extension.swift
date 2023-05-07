//
//  UILabel+Extension.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

extension UILabel {
    convenience init(text: String? = nil,
                     font: UIFont? = .systemFont(ofSize: 16),
                     textColor: UIColor? = .label,
                     numberOfLines: Int = 1,
                     textAlignment: NSTextAlignment = .left) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
    }
}
