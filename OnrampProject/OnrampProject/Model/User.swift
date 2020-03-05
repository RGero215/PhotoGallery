//
//  User.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/4/20.
//

import Foundation

struct User {
    let uid: String
    let fullName: String
    let imageUrl: String
    
    init(dictionary: [String: Any]) {
        let uid = dictionary["uid"] as? String ?? ""
        let fullName = dictionary["fullName"] as? String ?? ""
        let imageUrl = dictionary["imageUrl"] as? String ?? ""
        
        self.uid = uid
        self.fullName = fullName
        self.imageUrl = imageUrl
        
    }
}
