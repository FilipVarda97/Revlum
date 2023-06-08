//
//  RevlumIconButton.swift
//  
//
//  Created by Filip Varda on 08.06.2023..
//

import UIKit

class RevlumIconButton: UIButton {
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let edgeInsets = self.imageEdgeInsets
        let width = size.width + edgeInsets.left + edgeInsets.right
        let height = size.height + edgeInsets.top + edgeInsets.bottom
        return CGSize(width: width, height: height)
    }
}
