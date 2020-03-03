//
//  CustomTextField.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/3/20.
//

import UIKit

class CustomTexField: UITextField {
    
    let padding: CGFloat
    
    fileprivate func setupTextColor() {
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                //Light mode
                attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                textColor = .black
            } else {
                //DARK
                attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                textColor = .black
            }
        } else {
            // Fallback on earlier versions
            attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            textColor = .black
        }
    }
    
    init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
        
        setupTextColor()
        layer.cornerRadius = 16
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
