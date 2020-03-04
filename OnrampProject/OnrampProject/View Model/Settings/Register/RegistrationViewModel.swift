//
//  RegistrationViewModel.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/3/20.
//

import UIKit

class RegistrationViewModel {
    
    //MARK:- PROPERTIES
    var bindableImage = Bindable<UIImage>()
    var fullName: String? { didSet{checkFormValidity()} }
    var email: String? { didSet{checkFormValidity()} }
    var password: String? { didSet{checkFormValidity()} }
    var bindableIsFromValid = Bindable<Bool>()
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFromValid.value = isFormValid
    }

}
