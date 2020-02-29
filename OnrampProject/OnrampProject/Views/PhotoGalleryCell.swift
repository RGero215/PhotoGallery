//
//  PhotoGalleryCell.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import UIKit

class PhotoGalleryCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
