//
//  LightAndDarkMode.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 2/29/20.
//

import UIKit

extension RootViewController {
    
    // MARK: - LIGTH AND DARK MODE
    
    func setupLightAndDarkMode() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            
            if traitCollection.userInterfaceStyle == .light {
                //Light mode
                appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
                
                UINavigationBar.appearance().tintColor = .black
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            } else {
                //DARK
                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                
                UINavigationBar.appearance().tintColor = .white
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
            
        } else {
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().isTranslucent = false
        }
    }
}
