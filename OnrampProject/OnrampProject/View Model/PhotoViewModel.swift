//
//  PhotoViewModel.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/1/20.
//

import Foundation

class PhotoViewModel {
    
    //MARK: ERROR
    enum CaptureNarcosError: Error {
        case noArtworkAvailable
    }
    
    //MARK:- PROPERTIES
    typealias didFetchChaptersCompletion = ([ChapterData]?, CaptureNarcosError?) -> Void
    typealias didFetchArtworkCompletion = ([ArtworkData]?, CaptureNarcosError?) -> Void
    //Sync data fetch together
    let dispatchGroup = DispatchGroup()
    
    //MARK:- CLOUSER
    var didFetchChaptersData: didFetchChaptersCompletion?
    var didFetchArtworksData: didFetchArtworkCompletion?
    
    //MARK:- INITIALIZER
    init() {
        fetchData()
        fetchArtwork()
    }
    
    //MARK:- FILEPRIVATE FUNCTIONS
    fileprivate func fetchData() {
        dispatchGroup.enter()
        CaptureNarcos.shared.fetchChapters { [weak self] (chapters, err) in
            self?.dispatchGroup.leave()
            if let err = err {
                print("Failed to fetch chapters: ", err)
                self?.didFetchChaptersData?(nil, .noArtworkAvailable)
                return
            }
            
            guard let chapters = chapters else {return}
            self?.didFetchChaptersData?(chapters, nil)
            
            self?.fetchArtwork()
            
        }
    }
    
    fileprivate func fetchArtwork() {
        self.dispatchGroup.enter()
        CaptureNarcos.shared.fetchArtwork { [weak self] (artworks, err) in
            self?.dispatchGroup.leave()
            if let err = err {
                print("Failed to fetch artworks: ", err)
                self?.didFetchArtworksData?(nil, .noArtworkAvailable)
                return
            }
            guard let artworks = artworks else {return}
            self?.didFetchArtworksData?(artworks, nil)

        }
    }
    
}
