//
//  SettingsViewController.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/3/20.
//

import UIKit
import Firebase

class SettingsViewController: UITableViewController {
    
    //MARK:- UI COMPONENT
    lazy var imageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .red
        return button
    }()
    
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavItems()
        fetchUsersFromFirestore()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
    }
    
    //MARK:- FILEPRIVATE METHODS
    fileprivate func setupNavItems() {
        view.backgroundColor = .blue
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    //MARK:- HANDLE LOGOUT
    @objc fileprivate func handleLogout() {
        let registrationVC = RegistrationViewController()
        let nav = UINavigationController(rootViewController: registrationVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK:- HANDLE SAVE
    @objc fileprivate func handleSave() {
        
    }
    
    //MARK:- TABLEVIEW
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .blue
        header.addSubview(imageButton)
        imageButton.fillSuperview()
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.width
    }
}

//MARK:- EXTENSION

extension SettingsViewController {
    
    //MARK:- FETCHING FROM FIRESTORE
    fileprivate func fetchUsersFromFirestore() {
        Firestore.firestore().collection("users").getDocuments { (snapshot, err) in
            if let err = err {
                print("Failed to fetch users: ", err)
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                print(user)
            })
        }
    }
    
}
