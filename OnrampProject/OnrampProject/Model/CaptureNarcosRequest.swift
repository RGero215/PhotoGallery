//
//  CaptureNarcosRequest.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/1/20.
//

import Foundation

struct CaptureNarcosRequest {
    let baseUrl: URL
    let chapters: String
    let route: String
    
    var url: URL {
        return baseUrl.appendingPathComponent("\(chapters)/\(route)")
    }
}
