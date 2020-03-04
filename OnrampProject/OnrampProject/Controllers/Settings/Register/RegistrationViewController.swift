//
//  RegistrationViewController.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/3/20.
//

import UIKit

class RegistrationViewController: UIViewController {
    //MARK:- REGISTRATION VIEW
    var registrationView = RegistrationView()
    //MARK:- REGISTRATION VIEW MODEL
    let registrationViewModel = RegistrationViewModel()
    
    //MARK:- LOAD VIEWS
    override func loadView() {
        view = registrationView
        
    }
    
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        setupNotificationObservers()
        setupTapGesture()
        setupButtons()
        registrationView.scrollView.delegate = self
        setupRegistrationViewModelObserver()
        setupTextfieldTarget()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - OVERRIDE METHOD
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        registrationView.scrollView.contentSize = view.frame.size
        registrationView.scrollView.layoutIfNeeded()

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            handleTapDismiss()
            registrationView.overallStackView.axis = .horizontal
        } else {
            handleTapDismiss()
            registrationView.overallStackView.axis = .vertical
        }
    }
    
    
    //MARK:- TEXTFIELD DID BEGIN EDITING
    func textFieldDidBeginEditing(_ textField: UITextField) {
        registrationView.activeTextField = textField
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
    
    //MARK:- OBSERVERS
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- KEYBOARD SHOW
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - registrationView.scrollView.frame.origin.y - registrationView.scrollView.frame.height
        
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)

        registrationView.scrollView.contentInset.top = keyboardFrame.height
        
        // automatically scroll to visible active text field
        guard let activeTextField = registrationView.activeTextField else { return }
        let visibleRect = activeTextField.convert(activeTextField.bounds, to: registrationView.scrollView)
        registrationView.scrollView.scrollRectToVisible(visibleRect, animated: true)
    }
    
    //MARK:- KEYBOARD HIDE
    @objc fileprivate func handleKeyboardHide(notification: Notification){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut
            , animations: {
                self.view.transform = .identity
                self.registrationView.scrollView.contentInset.top = 0
                self.registrationView.scrollView.verticalScrollIndicatorInsets.top = 0
                
        })
    }
}

//MARK:- SCROLLVIEW PROTOCOLS
extension RegistrationViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}

//MARK:- SETUP BUTTON ACTIONS
extension RegistrationViewController {
    fileprivate func setupButtons() {

        registrationView.register.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        registrationView.goToLoginButton.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
    }
    
    fileprivate func setupTextfieldTarget() {
        registrationView.fullNameTextField.addTarget(self, action: #selector(handleTextChange(textField:)), for: .editingChanged)
        registrationView.emailTextField.addTarget(self, action: #selector(handleTextChange(textField:)), for: .editingChanged)
        registrationView.passwordTextField.addTarget(self, action: #selector(handleTextChange(textField:)), for: .editingChanged)
        
    }
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        switch textField {
        case registrationView.fullNameTextField:
            registrationViewModel.fullName = textField.text
        case registrationView.emailTextField:
            registrationViewModel.email = textField.text
        default:
            registrationViewModel.password = textField.text
        }


        
    }
    
    //MARK:- SETUP VIEW MODEL OBSERVER
    fileprivate func setupRegistrationViewModelObserver() {
        registrationViewModel.isFormValidObserver = { [unowned self] (isFormValid) in
            
            self.registrationView.register.isEnabled = isFormValid
            self.registrationView.register.backgroundColor = isFormValid ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : .black
            self.registrationView.register.setTitleColor(isFormValid ? .black : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: .normal)
        }
    }
}
