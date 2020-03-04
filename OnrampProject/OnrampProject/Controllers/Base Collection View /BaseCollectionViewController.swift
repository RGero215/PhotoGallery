//
//  BaseCollectionViewController.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import UIKit
import JGProgressHUD

class BaseCollectionViewController: UICollectionViewController {
    
    // MARK: - LOADING HUD PROPERTY
    
    let loadingHUD = JGProgressHUD(style: .dark)

    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        if #available(iOS 12.0, *) {
            let appearance = UINavigationBarAppearance()
            if traitCollection.userInterfaceStyle == .light {
             //Light mode
                appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

                UINavigationBar.appearance().tintColor = .white
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                collectionView.backgroundColor = .white

            } else {
              //DARK
                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

                UINavigationBar.appearance().tintColor = .white
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                collectionView.backgroundColor = .black

            }
                
            } else {
                UINavigationBar.appearance().tintColor = .white
                UINavigationBar.appearance().isTranslucent = false
                collectionView.backgroundColor = .white

            }
        }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
