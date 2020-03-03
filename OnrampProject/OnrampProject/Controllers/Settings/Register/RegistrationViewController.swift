//
//  RegistrationViewController.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/3/20.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    lazy var width = view.frame.width
    
    //MARK:- UI COMPONENTS
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Untitled_Artwork 5")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant:  width / 2).isActive = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    let fullNameTextField: CustomTexField = {
        let textField = CustomTexField(padding: 24)
        textField.placeholder = RegistrationPlaceHolder.name
        textField.backgroundColor = .white
        return textField
    }()
    
    let emailTextField: CustomTexField = {
        let textField = CustomTexField(padding: 24)
        textField.placeholder = RegistrationPlaceHolder.email
        textField.keyboardType = .emailAddress
        textField.backgroundColor = .white
        return textField
    }()
    
    let passwordTextField: CustomTexField = {
        let textField = CustomTexField(padding: 24)
        textField.placeholder = RegistrationPlaceHolder.password
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        return textField
    }()
    
    let register: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .black
        button.isEnabled = false
        button.setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: .disabled)
        button.layer.cornerRadius = 16
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
        return button
    }()
    
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        navigationController?.isNavigationBarHidden = true
        view.addSubview(backgroundImage)
        backgroundImage.fillSuperview()

        let stackView = VerticalStackView(arrangedSubviews: [selectPhotoButton, fullNameTextField, emailTextField, passwordTextField, register])
        
        view.addSubview(stackView)
        stackView.spacing = 8
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    //MARK:- FILEPRIVATE METHODS
    
    @objc fileprivate func handleRegister() {
        
    }
    
    @objc fileprivate func handleGoToLogin() {
        
    }
}
