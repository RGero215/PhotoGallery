//
//  PhotoGalleryCell.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import UIKit

class PhotoGalleryCell: UICollectionViewCell {
    
    //MARK:- COMPONENTS PROPERTIES
    
    let titleLabel = UILabel(text: "Photo Title", font: .boldSystemFont(ofSize: 30))
    
    //MARK: - HORIZONTAL CONTROLLER
    
    let horizontalController = PhotoHorizontalController()
    
    //MARK:- INITIALIZER
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
        addSubview(horizontalController.view)
        
        horizontalController.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
