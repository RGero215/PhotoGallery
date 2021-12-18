//
//  SettingsView.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/6/20.
//

import UIKit

class SettingsView: UIView, UITableViewDelegate {
    
    
    //MARK:- UI COMPONENT
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        setupLightAndDarkMode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    lazy var imageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.contentMode = .scaleAspectFill
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    //MARK:- HEADER
    lazy var header: UIView = {
        let header = UIView()
        header.addSubview(imageButton)
        imageButton.fillSuperview()
        return header
    }()
    
    
    
    
    //MARK:- HANDLE NOTIFY ME LIGTH/DARK
    func handleLightOrDarkMode(notifyMeCell: NotifyMeCell) {
        if #available(iOS 12.0, *) {
            notifyMeCell.bookSegment.backgroundColor = UIColor.black
            notifyMeCell.bookSegment.layer.borderColor = UIColor.white.cgColor
            notifyMeCell.bookSegment.selectedSegmentTintColor = UIColor.white
            notifyMeCell.bookSegment.layer.borderWidth = 1

            let titleBookTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            notifyMeCell.bookSegment.setTitleTextAttributes(titleBookTextAttributes, for:.normal)

            let titleBookTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.black]
            notifyMeCell.bookSegment.setTitleTextAttributes(titleBookTextAttributes1, for:.selected)
            
            notifyMeCell.gameSegment.backgroundColor = UIColor.black
            notifyMeCell.gameSegment.layer.borderColor = UIColor.white.cgColor
            notifyMeCell.gameSegment.selectedSegmentTintColor = UIColor.white
            notifyMeCell.gameSegment.layer.borderWidth = 1

            let titleGameTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            notifyMeCell.gameSegment.setTitleTextAttributes(titleGameTextAttributes, for:.normal)

            let titleGameTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.black]
            notifyMeCell.gameSegment.setTitleTextAttributes(titleGameTextAttributes1, for:.selected)
                
        }
    }
    
    fileprivate func setupLightAndDarkMode() {
        if #available(iOS 12.0, *) {
            let appearance = UINavigationBarAppearance()
            if traitCollection.userInterfaceStyle == .light {
             //Light mode
                appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

                UINavigationBar.appearance().tintColor = .white
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                self.tableView.backgroundView = UIView() //Create a backgroundView
                self.tableView.backgroundView!.backgroundColor = UIColor(white: 0.95, alpha: 1)
                
            } else {
              //DARK
                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

                UINavigationBar.appearance().tintColor = .white
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                self.tableView.backgroundView = UIView() //Create a backgroundView
                self.tableView.backgroundView!.backgroundColor = UIColor(red: 47/255.0 , green: 49/255.0 , blue: 52/255.0 , alpha: 1) //choose your background color

            }
            
        } else {
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().isTranslucent = false
            self.tableView.backgroundView = UIView() //Create a backgroundView
            self.tableView.backgroundView!.backgroundColor = UIColor(white: 0.95, alpha: 1)

        }
    }
    
    //MARK:- CELL TEXT COLOR
    fileprivate func setupTextColor(cell: SettingsCell) {
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                //Light mode
                cell.textField.attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                cell.textField.textColor = .black
            } else {
                //DARK
                cell.textField.attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                cell.textField.textColor = .white
            }
        } else {
            // Fallback on earlier versions
            cell.textField.attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            cell.textField.textColor = .black
        }
    }
}
