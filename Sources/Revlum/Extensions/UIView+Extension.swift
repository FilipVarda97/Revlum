//
//  File.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}
