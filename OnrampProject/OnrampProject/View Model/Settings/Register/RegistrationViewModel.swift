//
//  RegistrationViewModel.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/3/20.
//

import UIKit

class RegistrationViewModel {
    
    //MARK:- PROPERTIES
    var image: UIImage? { didSet {imageObserver?(image)} }
    var fullName: String? { didSet{checkFormValidity()} }
    var email: String? { didSet{checkFormValidity()} }
    var password: String? { didSet{checkFormValidity()} }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
    
    //MARK:- REACTIVE PROGRAMMING
    var isFormValidObserver: ((Bool) -> ())?
    var imageObserver: ((UIImage?) -> ())?
}
