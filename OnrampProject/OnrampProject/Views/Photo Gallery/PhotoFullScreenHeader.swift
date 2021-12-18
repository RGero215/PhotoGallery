//
//  PhotoFullScreenHeader.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import UIKit

class PhotoFullScreenHeader: UITableViewCell {
    
    
    //MARK:- PROPERTIES
    let photoCell = PhotoRowCell()
    
    
    //MARK:- COMPONENTS
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "close_button"), for: .normal)
        return button
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "playButton"), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    //MARK:- INITIALIZER
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(photoCell)
//        photoCell.centerInSuperview(size: .init(width: frame.width * 1.5, height: frame.width * 1.5))
        photoCell.fillSuperview()
        photoCell.imageView.layer.cornerRadius = 0
        
        contentView.addSubview(closeButton)
        closeButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 38))
        
        contentView.addSubview(playButton)
        playButton.centerInSuperview(size: .init(width: 80, height: 80))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
