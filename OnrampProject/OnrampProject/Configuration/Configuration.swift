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

enum RegistrationPlaceHolder {
    static let name = "Enter Full Name"
    static let email = "Enter Email"
    static let password = "Enter Password"
}

enum FetchingError {
    static let title = "Unable to Fetch Artwork"
    static let message = "The application is unable to fetch artwork data. Please make sure your device is connected over Wi-Fi or cellular."
}
