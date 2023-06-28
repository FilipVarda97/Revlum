//
//  UIColor+Extension.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import UIKit

extension UIColor {
    static let primaryColor: UIColor = {
        let bundle = Bundle.module
        let color = UIColor(named: "primaryColor", in: bundle, compatibleWith: nil)!
        return color
    }()
    static let secondaryColor: UIColor = {
        let bundle = Bundle.module
        let color = UIColor(named: "secondaryColor", in: bundle, compatibleWith: nil)!
        return color
    }()
    static let textMainColor: UIColor = {
        let bundle = Bundle.module
        let color = UIColor(named: "textMainColor", in: bundle, compatibleWith: nil)!
        return color
    }()
    static let textDescriptionColor: UIColor = {
        let bundle = Bundle.module
        let color = UIColor(named: "textDescriptionColor", in: bundle, compatibleWith: nil)!
        return color
    }()
    static let bgColor: UIColor = {
        let bundle = Bundle.module
        let color = UIColor(named: "bgColor", in: bundle, compatibleWith: nil)!
        return color
    }()
    static let newUsersOpacityColor: UIColor = {
        let bundle = Bundle.module
        let color = UIColor(named: "newUsersOpacityColor", in: bundle, compatibleWith: nil)!
        return color
    }()
    static let newUsersColor: UIColor = {
        let bundle = Bundle.module
        let color = UIColor(named: "newUsersColor", in: bundle, compatibleWith: nil)!
        return color
    }()
    static let separatorColor: UIColor = {
        let bundle = Bundle.module
        let color = UIColor(named: "separatorColor", in: bundle, compatibleWith: nil)!
        return color
    }()
    static let selectedSortBgColor: UIColor = {
        let bundle = Bundle.module
        let color = UIColor(named: "selectedSortBgColor", in: bundle, compatibleWith: nil)!
        return color
    }()
}
