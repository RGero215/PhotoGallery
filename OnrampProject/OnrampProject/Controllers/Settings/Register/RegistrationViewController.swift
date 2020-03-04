//
//  RegistrationViewController.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/3/20.
//

import UIKit

class RegistrationViewController: UIViewController {
    //MARK:- PROPERTIES
    lazy var width = view.frame.width
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
        stackView.distribution = .fillEqually
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
    
        navigationController?.isNavigationBarHidden = true
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        scrollView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - OVERRIDE METHOD
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            handleTapDismiss()
            overallStackView.axis = .horizontal
        } else {
            handleTapDismiss()
            overallStackView.axis = .vertical
        }
    }
    
    
    //MARK:- TEXTFIELD DID BEGIN EDITING
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    //MARK:- FILEPRIVATE METHODS
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
        self.view.transform = .identity
    }
    
    @objc fileprivate func handleRegister() {
        
    }
    
    @objc fileprivate func handleGoToLogin() {
        
    }
    
    
    //MARK:- SETUP LAYOUTS
    fileprivate func setupLayout() {
        view.addSubview(backgroundImage)
        backgroundImage.fillSuperview()
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        scrollView.contentSize = view.frame.size
        scrollView.addSubview(overallStackView)
        overallStackView.spacing = 8
        overallStackView.axis = .vertical
        selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        overallStackView.anchor(top: nil, leading: backgroundImage.leadingAnchor, bottom: nil, trailing: backgroundImage.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
    }
    
    //MARK:- OBSERVERS
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- KEYBOARD SHOW
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - scrollView.frame.origin.y - scrollView.frame.height
        
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)

        scrollView.contentInset.top = keyboardFrame.height
        
        // automatically scroll to visible active text field
        guard let activeTextField = activeTextField else { return }
        let visibleRect = activeTextField.convert(activeTextField.bounds, to: scrollView)
        scrollView.scrollRectToVisible(visibleRect, animated: true)
    }
    
    //MARK:- KEYBOARD HIDE
    @objc fileprivate func handleKeyboardHide(notification: Notification){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut
            , animations: {
                self.view.transform = .identity
        })
    }
}

//MARK:- SCROLLVIEW PROTOCOLS
extension RegistrationViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}
