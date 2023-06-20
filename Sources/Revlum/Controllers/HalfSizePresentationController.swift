//
//  HalfSizePresentationController.swift
//  
//
//  Created by Filip Varda on 20.06.2023..
//

import UIKit

class HalfSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }

        let height: CGFloat = 290
        let y = containerView.bounds.height - height
        return CGRect(x: 0, y: y, width: containerView.bounds.width, height: height)
    }
}
