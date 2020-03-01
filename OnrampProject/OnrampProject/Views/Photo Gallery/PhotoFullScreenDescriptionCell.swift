//
//  PhotoFullScreenDescriptionCell.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import UIKit

class PhotoFullScreenDescriptionCell: UITableViewCell {
    
    //MARK:- COMPONENTS
    let descriptionLabel = UILabel(text: "Description", font: .systemFont(ofSize: 20, weight: .regular), numberOfLines: 0)
    
    //MARK:- INITIALIZER
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.fillSuperview(padding: .init(top: 24, left: 24, bottom: 0, right: 24))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
