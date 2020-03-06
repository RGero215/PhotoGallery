//
//  LoginViewController.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/3/20.
//

import UIKit
import Firebase
import JGProgressHUD

class LoginViewController: UIViewController {
    //MARK:- LOGIN VIEW
    var loginView = LoginView()
    //MARK:- LOGIN VIEW MODEL
    let registrationViewModel = RegistrationViewModel()
    
    //MARK:- PROPERTIES
    let loginHUD = JGProgressHUD(style: .dark)
    
    //MARK:- LOAD VIEWS
    override func loadView() {
        view = loginView
        
    }
    
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        setupNotificationObservers()
        setupTapGesture()
        setupButtons()
        loginView.scrollView.delegate = self
        setupLoginViewModelObserver()
        setupTextfieldTarget()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - OVERRIDE METHOD
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        loginView.scrollView.contentSize = view.frame.size
        loginView.scrollView.layoutIfNeeded()

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            handleTapDismiss()
            loginView.verticalStackView.distribution = .fillEqually
        } else {
            handleTapDismiss()
            loginView.verticalStackView.distribution = .fill
        }
    }
    
    
    //MARK:- TEXTFIELD DID BEGIN EDITING
    func textFieldDidBeginEditing(_ textField: UITextField) {
        loginView.activeTextField = textField
    }
    
    //MARK:- FILEPRIVATE METHODS
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
        self.view.transform = .identity
    }
    
    //MARK:- HANDLE LOGIN
    @objc fileprivate func handleLogin() {
        self.handleTapDismiss()
        
        registrationViewModel.performRegistration { [weak self] (err) in
            if let err = err {
                self?.showHUDWithError(error: err)
                return
            }
            print("Finished registering user...")
        }
        
    }
    //MARK:- HANDLE GO TO REGISTER
    @objc fileprivate func handleGoToRegister() {
        let registerController = RegistrationViewController()
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        let animation = CATransition()
        animation.type = CATransitionType.fade
        self.navigationController?.view.layer.add(animation, forKey: "someAnimation")
        _ = navigationController?.pushViewController(registerController, animated: false)

        CATransaction.commit()
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
        let bottomSpace = view.frame.height - loginView.scrollView.frame.origin.y - loginView.scrollView.frame.height
        
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)

        loginView.scrollView.contentInset.top = keyboardFrame.height
        
        // automatically scroll to visible active text field
        guard let activeTextField = loginView.activeTextField else { return }
        let visibleRect = activeTextField.convert(activeTextField.bounds, to: loginView.scrollView)
        loginView.scrollView.scrollRectToVisible(visibleRect, animated: true)
    }
    
    //MARK:- KEYBOARD HIDE
    @objc fileprivate func handleKeyboardHide(notification: Notification){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut
            , animations: {
                self.view.transform = .identity
                self.loginView.scrollView.contentInset.top = 0
                self.loginView.scrollView.verticalScrollIndicatorInsets.top = 0
                
        })
    }
}

//MARK:- SCROLLVIEW PROTOCOLS
extension LoginViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}

//MARK:- SETUP BUTTON ACTIONS
extension LoginViewController {
    fileprivate func setupButtons() {

        loginView.login.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        loginView.goToRegistrationButton.addTarget(self, action: #selector(handleGoToRegister), for: .touchUpInside)
        
    }
    
    fileprivate func setupTextfieldTarget() {
        loginView.emailTextField.addTarget(self, action: #selector(handleTextChange(textField:)), for: .editingChanged)
        loginView.passwordTextField.addTarget(self, action: #selector(handleTextChange(textField:)), for: .editingChanged)
        
    }
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        switch textField {
        case loginView.emailTextField:
            registrationViewModel.email = textField.text
        default:
            registrationViewModel.password = textField.text
        }

    }
    
    //MARK:- SETUP VIEW MODEL OBSERVER
    fileprivate func setupLoginViewModelObserver() {
        registrationViewModel.bindableIsFromValid.bind  { [unowned self] (isFormValid) in
            
            guard let isFormValid = isFormValid else {return}
            
            self.loginView.login.isEnabled = isFormValid
            self.loginView.login.backgroundColor = isFormValid ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : .black
            self.loginView.login.setTitleColor(isFormValid ? .black : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: .normal)
        }
        
        registrationViewModel.bindableIsRegistering.bind { (isRegistering) in
            if isRegistering == true {
                self.loginHUD.textLabel.text = "Login"
                self.loginHUD.show(in: self.view)
            } else {
                self.loginHUD.dismiss()

            }
        }
    }
    
    //MARK:- HUD ERROR
    fileprivate func showHUDWithError(error: Error) {
        loginHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
}

