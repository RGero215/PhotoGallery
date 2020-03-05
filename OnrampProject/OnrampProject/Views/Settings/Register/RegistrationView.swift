//
//  RegistrationView.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/3/20.
//

import UIKit

class RegistrationView: UIView  {
    
    //MARK:- PROPERTIES
    var activeTextField: UITextField?
    
    //MARK:- UI COMPONENTS
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isDirectionalLockEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var verticalStackView: VerticalStackView = {
        let stackView = VerticalStackView(arrangedSubviews: [fullNameTextField, emailTextField, passwordTextField, register])
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var overallStackView = UIStackView(arrangedSubviews: [selectPhotoButton, verticalStackView])
    
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
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    lazy var selectPhotoButtonWidthAnchor = selectPhotoButton.widthAnchor.constraint(equalToConstant: 275)
    lazy var selectPhotoButtonHeightAnchor = selectPhotoButton.heightAnchor.constraint(equalToConstant: 275)
    
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
        
        return button
    }()
    
    let goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        return button
    }()
    
    // MARK:- INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    //MARK:- SETUP LAYOUTS
    fileprivate func setupLayout() {
        addSubview(backgroundImage)
        backgroundImage.fillSuperview()
        addSubview(scrollView)
        scrollView.fillSuperview()
        scrollView.addSubview(overallStackView)
        overallStackView.spacing = 8
        overallStackView.axis = .vertical
        overallStackView.anchor(top: nil, leading: backgroundImage.leadingAnchor, bottom: nil, trailing: backgroundImage.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
