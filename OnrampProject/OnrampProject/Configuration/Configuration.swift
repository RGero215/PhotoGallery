//
//  Configuration.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/1/20.
//

import Foundation

enum CaptureNarcosService {
    static let baseUrl = URL(string: "https://capturenarcosapi.herokuapp.com/")!
    static let chapters = "chapters"
    static let chapter = "chapter"
    static let artwork = "Artwork"
    static let song = "Song"
    static let animation = "Animation"
}

enum GalleryConfig {
    static let scene = "art.scnassets/art-gallery.scn"
    static let node = "portalNode"
}
