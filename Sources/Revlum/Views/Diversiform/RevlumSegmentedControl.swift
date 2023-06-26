//
//  RevlumSegmentedControl.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

class RevlumSegmentedControl: UISegmentedControl {
    private var selectedBackgroundView = UIView()

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

        if let backgroundView = subviews.first {
            backgroundView.layer.cornerRadius = 15
            backgroundView.clipsToBounds = true
        }
        removeBorders()
    }

    private func setupSelectedBackgroundView() {
        selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .red // Replace with the desired background color
        selectedBackgroundView.layer.cornerRadius = 15
        selectedBackgroundView.layer.shadowColor = UIColor.black.cgColor
        selectedBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        selectedBackgroundView.layer.shadowRadius = 4
        selectedBackgroundView.layer.shadowOpacity = 0.2
        insertSubview(selectedBackgroundView, at: 0)
        updateSelectedBackgroundViewFrame()
    }

    private func updateSelectedBackgroundViewFrame() {
        let segmentCount = CGFloat(numberOfSegments)
        let width = bounds.width / segmentCount
        let height = bounds.height - 8
        let x = CGFloat(selectedSegmentIndex) * width + 4
        selectedBackgroundView.frame = CGRect(x: x, y: 4, width: width - 8, height: height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateSelectedBackgroundViewFrame()
    }
       
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let previousSelectedSegmentIndex = selectedSegmentIndex
        super.touchesEnded(touches, with: event)
        if previousSelectedSegmentIndex != selectedSegmentIndex {
            animateSelectedBackgroundViewMovement()
        }
    }

    private func animateSelectedBackgroundViewMovement() {
        UIView.animate(withDuration: 0.3, animations: {
            self.updateSelectedBackgroundViewFrame()
        })
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
