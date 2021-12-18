//
//  RootViewController.swift
//  OnrampProject
//
//  Created by Giovanni Noa on 2/20/20.
//

import UIKit
import Firebase

final class RootViewController: UITabBarController {
    
    //MARK:- PROPERTIES
    let registration = RegistrationViewController()
    var user: User?
    

    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLightAndDarkMode()
        
        viewControllers = [
            createNavController(viewController: PhotoGalleryController(), title: "Photo Gallery", imageName: "iphoto-gallery"),
            createNavController(viewController: GalleryViewController(), title: "AR Gallery", imageName: "ARKit"),
            createNavController(viewController: SettingsViewController(), title: "Settings", imageName: "user"),
        ]

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if Auth.auth().currentUser?.uid != nil && UserDefaults.standard.value(forKey: Auth.auth().currentUser?.uid ?? "") == nil {
            UserDefaults.standard.set(true, forKey: Auth.auth().currentUser?.uid ?? "")
        }
        
        if  UserDefaults.standard.value(forKey: Auth.auth().currentUser?.uid ?? "") == nil {
            let nav = UINavigationController(rootViewController: self.registration)
            nav.navigationBar.isHidden = true
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
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
        case let viewController as SettingsViewController:
            viewController.viewModel = SettingsViewModel()
            viewController.user = self.user
            viewController.navigationItem.leftBarButtonItem?.tintColor = UIView().tintColor
            viewController.navigationItem.rightBarButtonItem?.tintColor = UIView().tintColor
        default:
            break
        }
        
        return navController
    }
    
    
    
    
    

}

