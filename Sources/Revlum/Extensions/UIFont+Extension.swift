//
//  UIFont+Extension.swift
//  
//
//  Created by Filip Varda on 31.05.2023..
//

import CoreGraphics
import CoreText
import Foundation

public class FontLoader {
    let fonts = [
        "Inter-Black.tff",
        "Inter-Bold.ttf",
        "Inter-ExtraBold.ttf",
        "Inter-ExtraLight.ttf",
        "Inter-Light.ttf",
        "Inter-Medium.ttf",
        "Inter-Regular.ttf",
        "Inter-SemiBold.ttf",
        "Inter-Thin.ttf"
    ]

    public init() {}

    public func loadFonts() {
        fonts.forEach { registerFont($0) }
    }

    func registerFont(_ fontFileName: String) {
        guard let fontURL = Bundle.module.url(forResource: fontFileName, withExtension: nil) else {
            print("Failed to find font: \(fontFileName)")
            return
        }

        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            print("Failed to load font: \(fontFileName)")
            return
        }

        guard let font = CGFont(fontDataProvider) else {
            print("Failed to create CGFont: \(fontFileName)")
            return
        }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("Error registering font: \(error.debugDescription)")
        }
    }
}
