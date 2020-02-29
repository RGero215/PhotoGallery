//
//  Songs.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import Foundation

struct Song: Decodable {
    let name: String
    let link: String
    let genre: String?
    let image: String?
    let video: String?
    let artist: String?
    let songwriter: String?
    let album: String?
    let description: String?
    let lyrics: String?
    let language: String?
}
