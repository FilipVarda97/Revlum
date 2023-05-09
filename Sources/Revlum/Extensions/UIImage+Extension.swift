//
//  UIImage+Extension.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

extension UIImage {
    static let topBGImage: UIImage = {
        let bundle = Bundle.module
        let image = UIImage(named: "backgroundImage", in: bundle, compatibleWith: nil)
        return image!
    }()
    static let revlumLogo: UIImage = {
        let bundle = Bundle.module
        let image = UIImage(named: "revlumLogo", in: bundle, compatibleWith: nil)
        return image!
    }()
}

extension UIImage {
    static let iosIcon: UIImage = {
        let bundle = Bundle.module
        let image = UIImage(named: "ios-icon", in: bundle, compatibleWith: nil)
        return image!
    }()
    static let desktopIcon: UIImage = {
        let bundle = Bundle.module
        let image = UIImage(named: "desktop-icon", in: bundle, compatibleWith: nil)
        return image!
    }()
}
