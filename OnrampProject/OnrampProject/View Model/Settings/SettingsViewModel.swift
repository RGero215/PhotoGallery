//
//  SettingsViewModel.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/6/20.
//

import Foundation
import Firebase
import SDWebImage

class SettingsViewModel {
    
    //MARK: ERROR
    enum UserError: Error {
        case noUserAvailable
    }
    var user: User?
    
    //MARK:- PROPERTIES
    typealias didFetchUserCompletion = (User?, UserError?) -> Void
    
    //MARK:- CLOUSER
    var didFetchUserData: didFetchUserCompletion?
    
    //MARK:- INITIALIZER
    init() {
        fetchCurrentUser()
    }
    
    //MARK:- FETCHING CURRENT USER
    fileprivate func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch users: ", err)
                self.didFetchUserData?(nil, .noUserAvailable)
                return
            }
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            self.user = user
            self.didFetchUserData?(user, nil)
            UserDefaults.standard.set(true, forKey: user.uid)

        }
    }
    
}
