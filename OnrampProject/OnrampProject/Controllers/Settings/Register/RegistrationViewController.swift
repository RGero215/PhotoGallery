//
//  RegistrationViewController.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/3/20.
//

import UIKit
import Firebase
import JGProgressHUD

class RegistrationViewController: UIViewController {
    //MARK:- REGISTRATION VIEW
    var registrationView = RegistrationView()
    //MARK:- REGISTRATION VIEW MODEL
    let registrationViewModel = RegistrationViewModel()
    
    //MARK:- PROPERTIES
    let registeringHUD = JGProgressHUD(style: .dark)
    
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
            registrationView.verticalStackView.distribution = .fillEqually
            registrationView.selectPhotoButtonHeightAnchor.isActive = false
            registrationView.selectPhotoButtonWidthAnchor.isActive = true
        } else {
            handleTapDismiss()
            registrationView.overallStackView.axis = .vertical
            registrationView.verticalStackView.distribution = .fill
            registrationView.selectPhotoButtonWidthAnchor.isActive = false
            registrationView.selectPhotoButtonHeightAnchor.isActive = true
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
    
    //MARK:- HANDLE REGISTER
    @objc fileprivate func handleRegister() {
        self.handleTapDismiss()
        
        registrationViewModel.performRegistration { [weak self] (err) in
            if let err = err {
                self?.showHUDWithError(error: err)
                return
            }
            print("Finished registering user...")
        }
        
    }
    //MARK:- HANDLE GO TO LOGIN
    @objc fileprivate func handleGoToLogin() {
        let loginController = LoginViewController()
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        let animation = CATransition()
        animation.type = CATransitionType.fade
        self.navigationController?.view.layer.add(animation, forKey: "someAnimation")
        _ = navigationController?.pushViewController(loginController, animated: false)

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

//MARK:- IMAGE PICKER PROTOCOLS
extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

//MARK:- SETUP BUTTON ACTIONS
extension RegistrationViewController {
    fileprivate func setupButtons() {

        registrationView.register.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        registrationView.goToLoginButton.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
        registrationView.selectPhotoButton.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
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
    
    @objc fileprivate func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    //MARK:- SETUP VIEW MODEL OBSERVER
    fileprivate func setupRegistrationViewModelObserver() {
        registrationViewModel.bindableIsFromValid.bind  { [unowned self] (isFormValid) in
            
            guard let isFormValid = isFormValid else {return}
            
            self.registrationView.register.isEnabled = isFormValid
            self.registrationView.register.backgroundColor = isFormValid ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : .black
            self.registrationView.register.setTitleColor(isFormValid ? .black : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: .normal)
        }
        
        registrationViewModel.bindableImage.bind { [unowned self] (image) in
            self.registrationView.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registrationViewModel.bindableIsRegistering.bind { (isRegistering) in
            if isRegistering == true {
                self.registeringHUD.textLabel.text = "Register"
                self.registeringHUD.show(in: self.view)
            } else {
                self.registeringHUD.dismiss()

            }
        }
    }
    
    //MARK:- HUD ERROR
    fileprivate func showHUDWithError(error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    
    
}
