//
//  RevlumSearchBarTextField.swift
//  
//
//  Created by Filip Varda on 08.06.2023..
//

import UIKit

class RevlumSearchBarTextField: UITextField {
    let textInset: UIEdgeInsets
    
    init(textInset: UIEdgeInsets) {
        self.textInset = textInset
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }
}
