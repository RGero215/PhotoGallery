//
//  PhotoHorizontalController.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import UIKit

class PhotoHorizontalController: HorizontalSnappingController {
    
    // MARK:- PROPERTIES
    let cellId = "cellId"
    var artworks = [ArtworkData]()
    var chapter: ChapterData!
    
    
    //MARK: PHOTO FULL SCREEN REFERENCE
    var photoFullScreenController: PhotoFullScreenController!
    
    //MARK:- CLOUSURE
    var didSelectHandler: ((ArtworkData) -> ())?
    
    // MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(PhotoRowCell.self, forCellWithReuseIdentifier: cellId)
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    
    }
    
    // MARK:- COLLECTION VIEW PROTOCOLS
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.artworks = self.artworks.filter { chapter.artwork.contains($0.id)}
        return artworks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PhotoRowCell
        self.artworks = self.artworks.filter{ chapter.artwork.contains($0.id)}
        let artwork = artworks[indexPath.item]
        let image = URL(string: artwork.image)
        cell?.artworkName.text = nil
        cell?.imageView.sd_setImage(with:image)
        return cell!
    }
    
    //MARK:- DID SELECT ARTWORK
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let artwork = artworks[indexPath.row]
        
        didSelectHandler?(artwork)
        
    }
}

extension PhotoHorizontalController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 48, height: view.frame.height - 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 8, left: 8, bottom: 0, right: 8)
    }
    
}


