//
//  PhotoGalleryController.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import UIKit
import SDWebImage

class PhotoGalleryController: BaseCollectionViewController {
    
    //MARK: - ALERT TYPE
    private enum AlertType {
        case noArtworkAvailable
    }
    
    //MARK: - PROPERTIES
    var viewModel: PhotoViewModel? {
        didSet {
            guard let viewModel = viewModel else {return}
            setupViewModel(with: viewModel)
        }
    }
    
    let cellId = "cellId"
    fileprivate var chapters = [ChapterData]()
    fileprivate var artworks = [ArtworkData]()
    var startingFrame: CGRect?
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    //MARK: - REFERENCE HORIZONTAL
    var photoFullScreenController: PhotoFullScreenController?
   
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(PhotoGalleryCell.self, forCellWithReuseIdentifier: cellId)
        
        // Add Activity Indicator
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- SETUP VIEW MODEL
    private func setupViewModel(with viewModel: PhotoViewModel) {
        viewModel.didFetchChaptersData = { [weak self] (chapters, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    self?.presentAlert(of: .noArtworkAvailable)
                }
                
            }
            guard let chapters = chapters else {return}
            self?.chapters = chapters
        }
        
        viewModel.didFetchArtworksData = {[weak self] (artworks, error) in
            if let error = error {
                print("Failed to fetch data: ", error)
            }
            guard let artworks = artworks else {return}
            self?.artworks = artworks
        }
        
        // Completion notification
        viewModel.dispatchGroup.notify(queue: .main) {
            print("Completed dispatch group task...")
            // Stop Activity indicator
            self.activityIndicatorView.stopAnimating()
            self.collectionView.reloadData()
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
        return .init(width: view.frame.width, height: view.frame.width)
    }

}


extension PhotoGalleryController {
    //MARK:- HANDLE REMOVE VIEW
    @objc func handleRemoveView() {
        navigationController?.popViewController(animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- PRESENT ALERT
    private func presentAlert(of alertType: AlertType) {
        let title: String
        let message: String
        
        switch alertType {
        case .noArtworkAvailable:
            title = FetchingError.title
            message = FetchingError.message
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}
