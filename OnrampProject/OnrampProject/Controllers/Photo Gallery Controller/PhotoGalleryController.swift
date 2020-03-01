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
    var startingFrame: CGRect?
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    //MARK: - REFERENCE HORIZONTAL
    var photoFullScreenController: PhotoFullScreenController?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
            
            let fullScreen = PhotoFullScreenController()
            
            fullScreen.artwork = artwork
            fullScreen.chapter = chapter
            
            fullScreen.dismissHandler = {
                self?.handleRemoveView()
            }
            
            let fullScreenView = fullScreen.view!
            self?.view.addSubview(fullScreenView)

            self?.photoFullScreenController = fullScreen
            
            guard let cell = collectionView.cellForItem(at: indexPath) else {return}
            
            // Absolute coordinate of cell
            guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else {return}
            self?.startingFrame = startingFrame
            
            // auto layout constrait animations
            fullScreenView.translatesAutoresizingMaskIntoConstraints = false
            self?.topConstraint = fullScreenView.topAnchor.constraint(equalTo: self!.view.topAnchor, constant: startingFrame.origin.y)
            self?.leadingConstraint = fullScreenView.leadingAnchor.constraint(equalTo: self!.view.leadingAnchor, constant: startingFrame.origin.x)
            self?.widthConstraint = fullScreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
            self?.heightConstraint = fullScreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)
            
            [self?.topConstraint, self?.leadingConstraint, self?.widthConstraint, self?.heightConstraint].forEach({$0?.isActive = true})
            
            self?.view.layoutIfNeeded()
            fullScreenView.layoutIfNeeded()
            
            
            fullScreenView.layer.cornerRadius = 16
            
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                
                self?.topConstraint?.constant = 0
                self?.leadingConstraint?.constant = 0
                self?.widthConstraint?.constant = (self?.view.frame.width)!
                self?.heightConstraint?.constant = (self?.view.frame.height)!
                
                self?.view.layoutIfNeeded()
                
                

                self?.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
                self?.tabBarController?.tabBar.frame.origin.y = (self?.view.frame.size.height)!
                self?.tabBarController?.tabBar.isHidden = true
            }, completion: nil)
            
            
            fullScreen.artwork = artwork
            
            // Add Fade animation
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            let animation = CATransition()
            animation.type = CATransitionType.fade
            self?.navigationController?.view.layer.add(animation, forKey: "didSelect")
            
            _ = self?.navigationController?.pushViewController(fullScreen, animated: false)
            CATransaction.commit()
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }

}


extension PhotoGalleryController {
    
    @objc func handleRemoveView() {
        navigationController?.popViewController(animated: false)

    }
}
