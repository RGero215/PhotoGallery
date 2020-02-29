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
        let urlString = "https://capturenarcosapi.herokuapp.com/chapters/chapter/"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    // MARK:- FETCH ARTWORKS
    func fetchArtwork(completion: @escaping ([Artwork]?, Error?) -> ()) {
        let urlString = "https://capturenarcosapi.herokuapp.com/chapters/Artwork/"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    // MARK:- FETCH SONGS
    func fetchSongs(completion: @escaping ([Song]?, Error?) -> ()) {
        let urlString = "https://capturenarcosapi.herokuapp.com/chapters/Song/"
        
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    // MARK:- FETCH ANIMATIONS
    func fetchAnimation(completion: @escaping ([Animation]?, Error?) -> ()) {
        let urlString = "https://capturenarcosapi.herokuapp.com/chapters/Animation/"
        
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    // MARK:- FETCH GENERIC JSON
    func fetchGenericJSONData<T: Codable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }
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
