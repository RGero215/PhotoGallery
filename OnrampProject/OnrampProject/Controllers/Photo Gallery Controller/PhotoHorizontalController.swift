//
//  PhotoHorizontalController.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import UIKit

class PhotoHorizontalController: BaseCollectionViewController {
    
    // MARK:- PROPERTIES
    let cellId = "cellId"
    
    
    // MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    
    }
    
    // MARK:- COLLECTION VIEW PROTOCOLS
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = .red
        
        return cell
    }
}
