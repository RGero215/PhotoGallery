//
//  TableViewDelegate.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/6/20.
//

import UIKit

class TableViewDelegate: NSObject, UITableViewDelegate {
    //MARK:- DELEGATE
    weak var delegate: ViewControllerDelegate?
    var settingsView: SettingsView?
    
    //MARK:- INITIALIZER
    init(withDelegate delegate: ViewControllerDelegate, settingsView: SettingsView) {
        self.delegate = delegate
        self.settingsView = settingsView
    }
    
    //MARK:- DID SELECT ROW
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.selectedCell(row: indexPath.row)
        switch indexPath.section {
        case 3:
            guard let url = URL(string: "http://www.capturenarcos.com/") else { return  }
            print("URL: ", url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case 4:
            guard let url = URL(string: "http://capturenarcos.myshopify.com/") else { return  }
            print("URL: ", url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        default:
            return
        }
       
    }
    
    //MARK:- VIEW FOR HEADER
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            
            return self.settingsView?.header
        }
        let headerLabel = HeaderLabel()
        switch section {
        case 1:
            headerLabel.text = "Full Name"
        case 2:
            headerLabel.text = "Email"
        case 3:
            headerLabel.text = "Capture Narcos Website"
        case 4:
            headerLabel.text = "Store Website"
        case 5:
            headerLabel.text = "Artist Name"
        default:
            headerLabel.text = "Notify Me When Available"
        }
        
        headerLabel.font = UIFont.boldSystemFont(ofSize: 24)
        return headerLabel
        
    }
    
    //MARK:- HEIGHT FOR HEADER
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return tableView.frame.width
        }
        return 40
    }

}
