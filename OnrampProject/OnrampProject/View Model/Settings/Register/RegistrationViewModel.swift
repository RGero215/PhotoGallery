//
//  RegistrationViewModel.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/3/20.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    //MARK:- BINDABLES
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    
    //MARK:- PROPERTIES
    var fullName: String? { didSet{checkFormValidity()} }
    var email: String? { didSet{checkFormValidity()} }
    var password: String? { didSet{checkFormValidity()} }
    
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        
        guard let email = email, let password = password else { return }
        
        bindableIsRegistering.value = true
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("Failed to register user: ", err)
                completion(err)
                return
            }
            print("Successfully register user: ", res?.user.uid ?? "")
            UserDefaults.standard.set(true, forKey: res?.user.uid ?? "")
            
            self.saveImageToFirebase(completion: completion)
            
            
        }
        
        
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()) {
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 1) ?? Data()
        
        ref.putData(imageData, metadata: nil) { (_, err) in
            if let err = err {
                completion(err)
                return
            }
            
            print("Finished uploading image to firebase storage")
            ref.downloadURL { (url, err) in
                if let err = err {
                    completion(err)
                    return
                }
                self.bindableIsRegistering.value = false
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFireStore(imageUrl: imageUrl, completion: completion)
            }
        }
        
    }
    
    fileprivate func saveInfoToFireStore(imageUrl: String, completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = ["fullName": fullName ?? "", "uid": uid, "imageUrl": imageUrl, "notifyMeBook": false, "notifyMeGame": false] as [String : Any]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
        }
    }

}
