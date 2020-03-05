//
//  User.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/4/20.
//

import Foundation

struct User {
    let uid: String
    var fullName: String
    var imageUrl: String
    var notifyMe: Bool
    
    
    init(dictionary: [String: Any]) {
        let uid = dictionary["uid"] as? String ?? ""
        let fullName = dictionary["fullName"] as? String ?? ""
        let imageUrl = dictionary["imageUrl"] as? String ?? ""
        let notifyMe = false
        
        self.uid = uid
        self.fullName = fullName
        self.imageUrl = imageUrl
        self.notifyMe = notifyMe
        
    }
}
