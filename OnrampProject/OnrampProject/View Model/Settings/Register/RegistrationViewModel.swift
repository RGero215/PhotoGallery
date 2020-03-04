//
//  RegistrationViewModel.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/3/20.
//

import UIKit

class RegistrationViewModel {
    
    //MARK:- BINDABLES
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFromValid = Bindable<Bool>()
    
    //MARK:- PROPERTIES
    var fullName: String? { didSet{checkFormValidity()} }
    var email: String? { didSet{checkFormValidity()} }
    var password: String? { didSet{checkFormValidity()} }
    
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFromValid.value = isFormValid
    }

}
