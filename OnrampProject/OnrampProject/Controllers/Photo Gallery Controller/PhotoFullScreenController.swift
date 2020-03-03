//
//  PhotoFullScreenController.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import UIKit
import AVFoundation
import AVKit

class PhotoFullScreenController: UITableViewController {
    
    // MARK:- PROPERTIES
    var artwork: ArtworkData?
    var chapter: ChapterData?
    var playButton: UIButton?
    var timeline: URL?
    
    //MARK:- CLOUSURE
    var dismissHandler: (() ->())?
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK:- STATUS BAR PREF
    override var prefersStatusBarHidden: Bool {
        return true
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
            timeline = URL(string: artwork?.timeline ?? "")
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
            if let height = view.superview?.frame.height {
                return height
            }
            
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
        
        let videoURL = timeline ?? URL(string: "")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        // Add Fade animation
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let animation = CATransition()
        animation.type = CATransitionType.fade
        self.navigationController?.view.layer.add(animation, forKey: "videoVC")

        _ = present(playerViewController, animated: false){
            player.play()
        }
        CATransaction.commit()
    }
}
