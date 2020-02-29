//
//  RootViewController.swift
//  OnrampProject
//
//  Created by Giovanni Noa on 2/20/20.
//

import UIKit

final class RootViewController: UITabBarController {

    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLightAndDarkMode()
        viewControllers = [
            createNavController(viewController: PhotoGalleryController(), title: "Photo Gallery", imageName: "iphoto-gallery"),
            createNavController(viewController: UIViewController(), title: "AR Gallery", imageName: "ARKit"),
            createNavController(viewController: UIViewController(), title: "User", imageName: "user"),
        ]
    }
    
    //MARK: - CREATE NAV CONTROLLER
    
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        navController.tabBarController?.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
    }
    
    // MARK: - LIGTH AND DARK MODE
    
    fileprivate func setupLightAndDarkMode() {
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

