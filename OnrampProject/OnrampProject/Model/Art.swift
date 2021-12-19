//
//  Art.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 12/18/21.
//

import Foundation

struct Art {
    let uid: String
    var name: String
    var artist: String
    var imageUrl: String?
    var forSale: Bool
    var sold: Bool
    
    
    init(dictionary: [String: Any]) {
        let uid = dictionary["uid"] as? String ?? ""
        let name = dictionary["name"] as? String ?? ""
        let artist = dictionary["artist"] as? String ?? ""
        let imageUrl = dictionary["imageUrl"] as? String
        let forSale = dictionary["forSale"] ?? false
        let sold = dictionary["sold"] ?? false
        
        self.uid = uid
        self.name = name
        self.artist = artist
        self.imageUrl = imageUrl
        self.forSale = forSale as! Bool
        self.sold = sold as! Bool
        
    }
}
