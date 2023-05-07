//
//  File.swift
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
}
