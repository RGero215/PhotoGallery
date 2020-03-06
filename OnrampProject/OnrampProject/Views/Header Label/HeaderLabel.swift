//
//  HeaderLabel.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/6/20.
//

import UIKit


//MARK:- HEADER LABEL CLASS
class HeaderLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
}
