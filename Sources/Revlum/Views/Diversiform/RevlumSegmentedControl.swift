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
        return CGSize(width: originalSize.width, height: 52)
    }

    private func setupControl() {
        selectedSegmentIndex = 0
        backgroundColor = .secondaryColor
        selectedSegmentTintColor = .bgColor
        setTitleTextAttributes([.foregroundColor: UIColor.textDescriptionColor], for: .normal)
        setTitleTextAttributes([.foregroundColor: UIColor.textMainColor], for: .selected)

        if let backgroundView = subviews.first {
            backgroundView.layer.cornerRadius = 15
            backgroundView.clipsToBounds = true
        }
        removeBorders()
    }

    private func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor ?? UIColor.clear), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: selectedSegmentTintColor ?? UIColor.clear), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }

    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}
