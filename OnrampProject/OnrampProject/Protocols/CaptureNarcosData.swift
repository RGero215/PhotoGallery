//
//  CaptureNarcosData.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/3/20.
//

import Foundation

protocol ChapterData {
    var chapter: String { get }
    var description: String { get }
    var artwork: [Int] { get }
}

protocol ArtworkData {
    var id: Int { get }
    var image: String { get }
    var animation: Int? { get }
    var song: Int? { get }
    var name: String { get }
    var timeline: String? { get }
    
}
