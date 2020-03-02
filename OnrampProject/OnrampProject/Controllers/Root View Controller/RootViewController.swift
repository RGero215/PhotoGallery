//
//  RootViewController.swift
//  OnrampProject
//
//  Created by Giovanni Noa on 2/20/20.
//

import UIKit

final class RootViewController: UITabBarController {
    
    //MARK:- PROPERTIES
    

    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLightAndDarkMode()
        
        viewControllers = [
            createNavController(viewController: PhotoGalleryController(), title: "Photo Gallery", imageName: "iphoto-gallery"),
            createNavController(viewController: GalleryViewController(), title: "AR Gallery", imageName: "ARKit"),
            createNavController(viewController: UIViewController(), title: "User", imageName: "user"),
        ]
        
        
    }
    
    //MARK: - CREATE NAV CONTROLLER
    
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        navController.tabBarItem?.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        // Dependency Injection
        switch viewController {
        case let viewController as PhotoGalleryController:
            viewController.viewModel = PhotoViewModel()
        default:
            break
        }
        
        return navController
    }
    
    

}

