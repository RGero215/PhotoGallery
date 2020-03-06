//
//  LoginView.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/5/20.
//

import UIKit

class LoginView: UIView  {
    
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
        let stackView = VerticalStackView(arrangedSubviews: [emailTextField, passwordTextField, login, goToRegistrationButton])
        stackView.spacing = 8
        return stackView
    }()
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Untitled_Artwork 5")
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    
    let emailTextField: CustomTexField = {
        let textField = CustomTexField(padding: 24)
        textField.placeholder = LoginPlaceHolder.email
        textField.keyboardType = .emailAddress
        textField.backgroundColor = .white
        return textField
    }()
    
    let passwordTextField: CustomTexField = {
        let textField = CustomTexField(padding: 24)
        textField.placeholder = LoginPlaceHolder.password
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        return textField
    }()
    
    let login: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .black
        button.isEnabled = false
        button.setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: .disabled)
        button.layer.cornerRadius = 16
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    let goToRegistrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to Register", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
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
        scrollView.addSubview(verticalStackView)
        verticalStackView.spacing = 8
        verticalStackView.axis = .vertical
        verticalStackView.anchor(top: nil, leading: backgroundImage.leadingAnchor, bottom: nil, trailing: backgroundImage.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

