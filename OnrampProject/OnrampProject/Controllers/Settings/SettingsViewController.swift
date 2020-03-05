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
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
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

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- HANDLE SELECT BUTTON
    @objc fileprivate func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    //MARK:- IMAGE PICKER
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true, completion: nil)
    }

    
}

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

//MARK:- CUSTOM IMAGE PICKER CONTROLLER
class CustomImagePickerController: UIImagePickerController {
    
    var imageButton: UIButton?
}
