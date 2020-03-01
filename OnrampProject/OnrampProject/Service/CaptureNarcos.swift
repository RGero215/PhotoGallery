//
//  CaptureNarcos.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import Foundation
import UIKit

class CaptureNarcos {
    
    // MARK:- SINGLETON
    
    static let shared = CaptureNarcos()
    
    // MARK:- FETCH CHAPTERS
    func fetchChapters(completion: @escaping ([Chapters]?, Error?) -> ()) {
        let url = CaptureNarcosRequest(baseUrl: CaptureNarcosService.baseUrl, chapters: CaptureNarcosService.chapters, route: CaptureNarcosService.chapter)
        
        fetchGenericJSONData(url: url.url, completion: completion)
    }
    
    // MARK:- FETCH ARTWORKS
    func fetchArtwork(completion: @escaping ([Artwork]?, Error?) -> ()) {
        let url = CaptureNarcosRequest(baseUrl: CaptureNarcosService.baseUrl, chapters: CaptureNarcosService.chapters, route: CaptureNarcosService.artwork)
    
        fetchGenericJSONData(url: url.url, completion: completion)
    }

    // MARK:- FETCH SONGS
    func fetchSongs(completion: @escaping ([Song]?, Error?) -> ()) {
        let url = CaptureNarcosRequest(baseUrl: CaptureNarcosService.baseUrl, chapters: CaptureNarcosService.chapters, route: CaptureNarcosService.song)

        fetchGenericJSONData(url: url.url, completion: completion)
    }

    // MARK:- FETCH ANIMATIONS
    func fetchAnimation(completion: @escaping ([Animation]?, Error?) -> ()) {
        let url = CaptureNarcosRequest(baseUrl: CaptureNarcosService.baseUrl, chapters: CaptureNarcosService.chapters, route: CaptureNarcosService.animation)

        fetchGenericJSONData(url: url.url, completion: completion)
    }
    
    // MARK:- FETCH GENERIC JSON
    func fetchGenericJSONData<T: Codable>(url: URL, completion: @escaping (T?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
                   
           if let err = err {
               completion(nil, err)
               return
           }
           
           do {
               let objects = try JSONDecoder().decode(T.self, from: data!)
               completion(objects, nil)
           } catch {
               completion(nil, error)
               print("Failed to decode: ", error)
           }
           
       }.resume()
    }
}
