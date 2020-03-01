//
//  PhotoFullScreenController.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import UIKit

class PhotoFullScreenController: UITableViewController {
    
    // MARK:- PROPERTIES
    var artwork: Artwork?
    var chapter: Chapters?
    var playButton: UIButton?
    
    //MARK:- CLOUSURE
    var dismissHandler: (() ->())?
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    //MARK:- TABLE VIEW PROTOCOLS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            let headerCell = PhotoFullScreenHeader()
            headerCell.closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            headerCell.playButton.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
            headerCell.photoCell.artwork = artwork
            headerCell.photoCell.artworkName.text = nil
            headerCell.photoCell.imageView.sd_setImage(with: URL(string: artwork!.image))
            self.playButton = headerCell.playButton
            return headerCell
            
        }
        
        let cell = PhotoFullScreenDescriptionCell()
        
        let attributedText = NSMutableAttributedString(string: "Name: \(artwork?.name ?? "")", attributes: [.foregroundColor: UIColor.gray])
        guard let chapter = chapter?.description else {return cell}
        attributedText.append(NSAttributedString(string: "\n\n Chapter Short Description: \n\n\(chapter)", attributes: [.foregroundColor: UIColor.gray]))
        cell.descriptionLabel.attributedText = attributedText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 450
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    // MARK:- OBJC FUNCTIONS
    @objc fileprivate func handleDismiss(button: UIButton) {
        button.isHidden = true
        playButton?.isHidden = true
        dismissHandler?()
    }
    
    @objc fileprivate func handlePlay(button: UIButton) {
        let videoVC = UIViewController()
        // Add Fade animation
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let animation = CATransition()
        animation.type = CATransitionType.fade
        self.navigationController?.view.layer.add(animation, forKey: "videoVC")
        
        _ = self.navigationController?.pushViewController(videoVC, animated: false)
        CATransaction.commit()
    }
}
