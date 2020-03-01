//
//  HorizontalSnappingController.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/1/20.
//

import UIKit

class HorizontalSnappingController: UICollectionViewController {
    init() {
        let layout = BetterSnappingLayout()
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                //Light mode
                collectionView.backgroundColor = .white
                
            } else {
                //DARK
                collectionView.backgroundColor = .black
            }
        } else {
            // Fallback on earlier versions
            collectionView.backgroundColor = .white
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
