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
        view.backgroundColor = .blue
        viewControllers = [
            createNavController(viewController: UIViewController(), title: "Photo Gallery", imageName: "iphoto-gallery"),
            createNavController(viewController: UIViewController(), title: "AR Gallery", imageName: "ARKit"),
            createNavController(viewController: UIViewController(), title: "User", imageName: "user"),
        ]
    }
    
    //MARK: - CREATE NAV CONTROLLER
    
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationController?.title = title
        viewController.view.backgroundColor = .white
        navController.tabBarController?.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
    }


}

