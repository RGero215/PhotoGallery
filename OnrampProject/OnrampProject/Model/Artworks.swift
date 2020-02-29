//
//  Artwork.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import Foundation


struct Artwork: Codable {
    let id: Int
    let image: String
    let animation: Int?
    let song: Int?
    let name: String
    let timeline: String?
}
