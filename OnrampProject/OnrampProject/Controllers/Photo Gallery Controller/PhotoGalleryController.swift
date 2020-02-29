//
//  PhotoGalleryController.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import UIKit
import SDWebImage

class PhotoGalleryController: BaseCollectionViewController {
    
    //MARK: - PROPERTIES
    let cellId = "cellId"
    fileprivate var chapters = [Chapters]()
    fileprivate var artworks = [Artwork]()
    
    //MARK: - ACTIVITY INDICATOR
    let activityIndicartorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    // Sync data fetch together
    let dispatchGroup = DispatchGroup()
    
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(PhotoGalleryCell.self, forCellWithReuseIdentifier: cellId)
        
        // Add Activity Indicator
        view.addSubview(activityIndicartorView)
        activityIndicartorView.fillSuperview()
        
        // fetch photos
        fetchData()
        fetchArtwork()
        
        // Completion notification
        dispatchGroup.notify(queue: .main) {
            print("Completed dispatch group task...")
            // Stop Activity indicator
            self.activityIndicartorView.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    //MARK:- FILEPRIVATE FUNCTIONS
    
    fileprivate func fetchData() {
        dispatchGroup.enter()
        CaptureNarcos.shared.fetchChapters { (chapters, err) in
            self.dispatchGroup.leave()
            if let err = err {
                print("Failed to fetch chapters: ", err)
                return
            }
            
            guard let chapters = chapters else {return}
            self.chapters = chapters
            
            self.fetchArtwork()
            
        }
    }
    
    fileprivate func fetchArtwork() {
        self.dispatchGroup.enter()
        CaptureNarcos.shared.fetchArtwork { (artworks, err) in
            self.dispatchGroup.leave()
            if let err = err {
                print("Failed to fetch artworks: ", err)
                return
            }
            guard let artworks = artworks else {return}
            self.artworks = artworks
        }
    }
    
    
}

extension PhotoGalleryController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapters.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PhotoGalleryCell
        let chapter = chapters[indexPath.item]
        cell?.titleLabel.text = chapter.chapter
        cell?.horizontalController.artworks = self.artworks
        cell?.horizontalController.chapter = chapter
        cell?.horizontalController.collectionView.reloadData()
        
        cell?.horizontalController.didSelectHandler = { [weak self] artwork in
            
            // Add Fade animation
            let artworkDetailController = UIViewController()
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            let animation = CATransition()
            animation.type = CATransitionType.fade
            self?.navigationController?.view.layer.add(animation, forKey: "didSelect")
            
            _ = self?.navigationController?.pushViewController(artworkDetailController, animated: false)
            CATransaction.commit()
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }

}
