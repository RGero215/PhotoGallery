//
//  SettingsViewController.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/3/20.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol ViewControllerDelegate: class {
    func selectedCell(row: Int)
}

class SettingsViewController: UIViewController {
    
    
    //MARK:- VIEW MODEL
    var viewModel: SettingsViewModel? {
        didSet {
            guard let viewModel = viewModel else {return}
            setupViewModel(with: viewModel)
        }
    }
    
   
    //MARK:- TABLE VIEW DELEGATE
    var tableViewDelegate: TableViewDelegate?
    
    //MARK:- SETTINGSVIEW
    var settingsView = SettingsView()
    
    //MARK:- LOAD VIEWS
    override func loadView() {
        view = settingsView
    }
    
    //MARK:- PROPERTIES
    let cellId = "cellId"
    var user: User?
    
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavItems()

        self.user = self.viewModel?.user
        self.settingsView.imageButton.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        self.tableViewDelegate = TableViewDelegate(withDelegate: self, settingsView: self.settingsView)
    
        self.settingsView.tableView.delegate = self.tableViewDelegate
        self.settingsView.tableView.dataSource = self
        self.settingsView.tableView.register(SettingsCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel?.fetchCurrentUser()
        self.settingsView.tableView.reloadData()
        print("Reloading...")
    }
    
    //MARK:- FILEPRIVATE METHODS
    fileprivate func setupNavItems() {
        view.backgroundColor = .blue
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    //MARK:- HANDLE LOGOUT
    @objc fileprivate func handleLogout() {
        try? Auth.auth().signOut()
        let registrationVC = RegistrationViewController()
        let nav = UINavigationController(rootViewController: registrationVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK:- HANDLE SAVE
    @objc fileprivate func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let docData = [
            "uid": uid,
            "fullName": user?.fullName ?? "",
            "imageUrl": user?.imageUrl ?? "",
            "notifyMeBook": user?.notifyMeBook ?? false,
            "notifyMeGame": user?.notifyMeGame ?? false
            ] as [String : Any]
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Settings"
        hud.show(in: view)
        print("Doc DATA: ", docData)
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            hud.dismiss()
            if let err = err {
                print("Failed to save user settings: ", err)
                return
            }
            print("Finished saving user info")
            self.settingsView.tableView.reloadData()
        }
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
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 1) else {return}
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: view)
        ref.putData(uploadData, metadata: nil) { (nil, err) in
            hud.dismiss()
            if let err = err {
                print("Failed to upload image to storage: ", err)
                return
            }
            
            ref.downloadURL { (url, err) in
                hud.dismiss()
                if let err = err {
                    print("Failed to fetch download URL: ", err)
                    return
                }
                
                self.user?.imageUrl = url?.absoluteString
                
            }
        }
    } 
}

extension SettingsViewController: ViewControllerDelegate {
    
    //MARK:- PROTOCOL
    func selectedCell(row: Int) {
        print("Row: ", row)
    }
    
    //MARK:- SETUP VIEW MODEL
    
    private func setupViewModel(with viewModel: SettingsViewModel) {
        viewModel.didFetchUserData = { [weak self] (user, error) in
            if let _ = error {
                print("Failed to fetch user: ")
            }
            guard let user = user else {return}
            self?.user = user
            self?.loadUserPhoto()

        }
         
    }
    
    //MARK:- LOAD USER PHOTO
    fileprivate func loadUserPhoto() {
        guard let imageUrl = user?.imageUrl, let url = URL(string: imageUrl) else {return}
        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
            self.settingsView.imageButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            self.settingsView.tableView.reloadData()
        }
    }
    
    //MARK:- HANDLE NAME CHANGE
    @objc func handleNameChange(textField: UITextField) {
        self.user?.fullName = textField.text ?? ""
        print(textField.text)
        
    }
    
    //MARK:- HANDLE BOOK AVAILABLE
    @objc func handleBookNotifyMe(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            self.user?.notifyMeBook = false
        case 1:
            self.user?.notifyMeBook = true
        default:
            break
        }
    }
    
    
    //MARK:- HANDLE GAME AVAILABLE
    @objc func handleGameNotifyMe(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            self.user?.notifyMeGame = false
        case 1:
            self.user?.notifyMeGame = true
        default:
            break
        }
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    //MARK:- NUMBER OF SECTONS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    //MARK:- NUMBER OF ROW IN SECTION
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    //MARK:- CELL FOR ROW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 6 {
            let notifyMeCell = NotifyMeCell(style: .default, reuseIdentifier: nil)
            
            settingsView.handleLightOrDarkMode(notifyMeCell: notifyMeCell)
            
            
            notifyMeCell.bookSegment.addTarget(self, action: #selector(handleBookNotifyMe), for: .valueChanged)
            
            notifyMeCell.gameSegment.addTarget(self, action: #selector(handleGameNotifyMe), for: .valueChanged)
            
            notifyMeCell.bookSegment.selectedSegmentIndex = self.user?.notifyMeBook ?? false ? 1 : 0
            
            notifyMeCell.gameSegment.selectedSegmentIndex = self.user?.notifyMeGame ?? false ? 1 : 0
            
            return notifyMeCell
        }
        
        let cell = self.settingsView.tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingsCell

        switch indexPath.section {
        case 1:
            cell.textField.text = user?.fullName
            cell.textField.placeholder = "Enter Full Name"
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            if let email = Auth.auth().currentUser?.email {
                cell.textField.text = email
                cell.textField.isEnabled = false
            }
        case 3:
            cell.textField.text = "http://www.capturenarcos.com/"
            cell.textField.isEnabled = false
        case 4:
            cell.textField.text = "http://capturenarcos.myshopify.com/"
            cell.textField.isEnabled = false
        case 5:
            cell.textField.text = "Ramon Geronimo"
            cell.textField.isEnabled = false
        default:
            cell.textField.text = "Book | Game Available "
        }

        return cell
    }
}

