//
//  PhotoGalleryController.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import UIKit


class PhotoGalleryController: BaseCollectionViewController {
    
    let cellId = "cellId"
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(PhotoGalleryCell.self, forCellWithReuseIdentifier: cellId)
    }
}

extension PhotoGalleryController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PhotoGalleryCell
        
        
        return cell!
    }
}
