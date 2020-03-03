//
//  PhotoRowCell.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import UIKit

class PhotoRowCell: UICollectionViewCell {
    
    //MARK:- PROPERTIES
    var artwork: ArtworkData! {
        didSet {
            imageView.sd_setImage(with: URL(string: artwork.image))
            artworkName.text = "Name: \(artwork.name)"
        }
    }
    
    
    
    //MARK:- COMPONENTS
    let imageView =  UIImageView(cornerRadius: 16)
    
    let artworkName = UILabel(text: "Name", font: .boldSystemFont(ofSize: 26), numberOfLines: 2)
    
    //MARK:- INITIALIZER
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFill
        let imageContainerView = UIView()
        imageContainerView.addSubview(imageView)
        imageView.fillSuperview()
        
        artworkName.textColor = .white
        artworkName.backgroundColor = UIColor(red: 0/255.0 , green: 0/255.0 , blue: 0/255.0 , alpha: 0.5)
        
        let stackView = VerticalStackView(arrangedSubviews: [imageContainerView, artworkName])
        contentView.addSubview(stackView)
        stackView.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
