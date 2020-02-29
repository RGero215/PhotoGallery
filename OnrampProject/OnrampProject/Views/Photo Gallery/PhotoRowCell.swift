//
//  PhotoRowCell.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import UIKit

class PhotoRowCell: UICollectionViewCell {
    
    //MARK:- COMPONENTS
    let imageView =  UIImageView(cornerRadius: 16)
    
    //MARK:- LIFE CYCLE
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
