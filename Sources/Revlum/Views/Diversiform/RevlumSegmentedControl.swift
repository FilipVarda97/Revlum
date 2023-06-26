//
//  RevlumSegmentedControl.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

class RevlumSegmentedControl: UISegmentedControl {
    private var selectedBackgroundView = UIView()
    private var selectedBackgroundViewLeftAnchor: NSLayoutConstraint!

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
        selectedSegmentTintColor = .red
        setTitleTextAttributes([.foregroundColor: UIColor.textDescriptionColor], for: .normal)
        setTitleTextAttributes([.foregroundColor: UIColor.textMainColor], for: .selected)
        addTarget(self, action: #selector(updateSelectedBackgroundView), for: .valueChanged)

        if let backgroundView = subviews.first {
            backgroundView.layer.cornerRadius = 15
            backgroundView.clipsToBounds = true
        }
        removeBorders()
        setupSelectedBackgroundView()
    }

    private func setupSelectedBackgroundView() {
        selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .bgColor
        selectedBackgroundView.layer.cornerRadius = 15
        selectedBackgroundView.layer.shadowColor = UIColor.black.cgColor
        selectedBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        selectedBackgroundView.layer.shadowRadius = 2
        selectedBackgroundView.layer.shadowOpacity = 0.2
        addSubview(selectedBackgroundView)
        selectedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        selectedBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        selectedBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        selectedBackgroundView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / CGFloat(numberOfSegments)).isActive = true
        selectedBackgroundViewLeftAnchor = selectedBackgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
        selectedBackgroundViewLeftAnchor.isActive = true
        updateSelectedBackgroundView()
    }

    @objc private func updateSelectedBackgroundView() {
        let padding: CGFloat
        let paddingSpace: CGFloat = 4

        if selectedSegmentIndex == 0 {
            padding = paddingSpace
        } else if selectedSegmentIndex == numberOfSegments - 1 {
            padding = (frame.width / CGFloat(numberOfSegments) * selectedSegmentIndex - 1) - paddingSpace
        } else {
            padding = frame.width * CGFloat(selectedSegmentIndex) / CGFloat(numberOfSegments)
        }

        selectedBackgroundViewLeftAnchor.constant = padding

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

    private func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor ?? UIColor.clear), for: .normal, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }

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
