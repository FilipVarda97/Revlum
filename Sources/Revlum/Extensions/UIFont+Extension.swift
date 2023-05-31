//
//  UIFont+Extension.swift
//  
//
//  Created by Filip Varda on 31.05.2023..
//

import UIKit

public func registerCommonFonts() {
    let fonts = [
        "Inter-Black.ttf",
        "Inter-Bold.ttf",
        "Inter-ExtraBold.ttf",
        "Inter-ExtraLight.ttf",
        "Inter-Light.ttf",
        "Inter-Medium.ttf",
        "Inter-Regular.ttf",
        "Inter-SemiBold.ttf",
        "Inter-Thin.ttf"
    ]

    for font in fonts {
        UIFont.registerFont(bundle: Bundle.module, fontName: font)
    }
}

extension UIFont {
    /// - Parameters:
    ///   - bundle: Bundle
    ///   - fontName: String
    static func registerFont(bundle: Bundle, fontName: String) {
        let pathForResourceString = bundle.path(forResource: fontName, ofType: nil)
        let fontData = NSData(contentsOfFile: pathForResourceString!)
        let dataProvider = CGDataProvider(data: fontData!)
        let fontRef = CGFont(dataProvider!)
        var errorRef: Unmanaged<CFError>? = nil
        
        if let fontRef = fontRef,
            (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
            print("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
        else {
            print("Failed to register font - bundle identifier invalid.")
        }
    }
}
