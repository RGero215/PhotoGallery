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
    var imageUrl: String?
    var notifyMeBook: Bool
    var notifyMeGame: Bool
    
    
    init(dictionary: [String: Any]) {
        let uid = dictionary["uid"] as? String ?? ""
        let fullName = dictionary["fullName"] as? String ?? ""
        let imageUrl = dictionary["imageUrl"] as? String
        let notifyMeBook = dictionary["notifyMeBook"] ?? false
        let notifyMeGame = dictionary["notifyMeGame"] ?? false
        
        self.uid = uid
        self.fullName = fullName
        self.imageUrl = imageUrl
        self.notifyMeBook = notifyMeBook as! Bool
        self.notifyMeGame = notifyMeGame as! Bool
        
    }
}
