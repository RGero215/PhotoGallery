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


class SettingsViewController: UITableViewController {
    
    //MARK:- PROPERTIES
    let cellId = "cellId"
    var user: User?
    
    //MARK:- UI COMPONENT
    lazy var imageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
    //MARK:- HEADER
    lazy var header: UIView = {
        let header = UIView()
        header.backgroundColor = .blue
        header.addSubview(imageButton)
        imageButton.fillSuperview()
        return header
    }()
    
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavItems()
        fetchCurrentUser()
        tableView.register(SettingsCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        setupLightAndDarkMode()
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
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            hud.dismiss()
            if let err = err {
                print("Failed to save user settings: ", err)
                return
            }
            print("Finished saving user info")
            self.tableView.reloadData()
        }
    }
    
    //MARK:- VIEW FOR HEADER
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            
            return header
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
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return view.frame.width
        }
        return 40
    }
    
    //MARK:- NUMBER OF SECTONS
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    //MARK:- NUMBER OF ROW IN SECTION
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    //MARK:- CELL FOR ROW
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 6 {
            let notifyMeCell = NotifyMeCell(style: .default, reuseIdentifier: nil)
            
            handleLightOrDarkMode(notifyMeCell: notifyMeCell)
            
            notifyMeCell.bookSegment.addTarget(self, action: #selector(handleBookNotifyMe), for: .valueChanged)
            
            notifyMeCell.gameSegment.addTarget(self, action: #selector(handleGameNotifyMe), for: .valueChanged)
            
            notifyMeCell.bookSegment.selectedSegmentIndex = self.user?.notifyMeBook ?? false ? 1 : 0
            
            notifyMeCell.gameSegment.selectedSegmentIndex = self.user?.notifyMeGame ?? false ? 1 : 0
            
            return notifyMeCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingsCell
        
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
    
    //MARK:- DID SELECT ROW
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

extension SettingsViewController {
    
    //MARK:- HANDLE NAME CHANGE
    @objc fileprivate func handleNameChange(textField: UITextField) {
        self.user?.fullName = textField.text ?? ""
    }
    
    //MARK:- HANDLE BOOK AVAILABLE
    @objc fileprivate func handleBookNotifyMe(sender: UISegmentedControl) {
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
    @objc fileprivate func handleGameNotifyMe(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            self.user?.notifyMeGame = false
        case 1:
            self.user?.notifyMeGame = true
        default:
            break
        }
    }
    
    //MARK:- FETCHING CURRENT USER
    fileprivate func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch users: ", err)
                return
            }
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            print("User: ", user)
            self.user = user
            UserDefaults.standard.set(true, forKey: self.user?.uid ?? "")
            self.loadUserPhoto()
            
            self.tableView.reloadData()
        }
    }
    
    //MARK:- LOAD USER PHOTO
    fileprivate func loadUserPhoto() {
        guard let imageUrl = user?.imageUrl, let url = URL(string: imageUrl) else {return}
        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
            self.imageButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    //MARK:- HANDLE NOTIFI ME LIGTH/DARK
    fileprivate func handleLightOrDarkMode(notifyMeCell: NotifyMeCell) {
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

//MARK:- CUSTOM IMAGE PICKER CONTROLLER
class CustomImagePickerController: UIImagePickerController {
    
    var imageButton: UIButton?
}

//MARK:- HEADER LABEL CLASS
class HeaderLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
}
