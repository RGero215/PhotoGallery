//
//  GalleryViewController.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/1/20.
//

import UIKit
import SceneKit
import ARKit
import Firebase
import JGProgressHUD
import SDWebImage

class GalleryViewController: UIViewController, ARSCNViewDelegate {

    var sceneView: ARSCNView = {
        let ar = ARSCNView()
        
        return ar
    }()
    
    
    var planes :[Plane] = [Plane]()
    
    var art: Art?
    var user: User?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        view.addSubview(sceneView)
        
        sceneView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        // Set the view's delegate
        sceneView.delegate = self
        
        self.sceneView.autoenablesDefaultLighting = true
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        
        registerGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //MARK:- METHODS
    var isAdded = false
    @objc func tapped(recognizer :UITapGestureRecognizer) {
        
        let sceneView = recognizer.view as! ARSCNView
        let touchLocation = recognizer.location(in: sceneView)
        
        let hitTestResults = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        let results = sceneView.hitTest(touchLocation, options: [:])

        if !hitTestResults.isEmpty {
            guard let hitTestResult = hitTestResults.first else {return}
            if !isAdded {
                addPortal(ht :hitTestResult)
            }
        }
    }
    
    // this function adds the portal model to the real world
    private func addPortal(ht :ARHitTestResult) {
        
        if let portalScene = SCNScene(named: GalleryConfig.scene) {
            if let portalNode = portalScene.rootNode.childNode(withName: GalleryConfig.node, recursively: true) {
                
                portalNode.position = SCNVector3(ht.worldTransform.columns.3.x, ht.worldTransform.columns.3.y, ht.worldTransform.columns.3.z)
                
                self.sceneView.scene.rootNode.addChildNode(portalNode)
                isAdded = true
            }
             
        }
        
        
    }
    
    private func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if !(anchor is ARPlaneAnchor) {
            return
        }
        
        let plane = Plane(anchor: anchor as! ARPlaneAnchor)
        self.planes.append(plane)
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        let plane = self.planes.filter { plane in
            return plane.anchor.identifier == anchor.identifier
            }.first
        
        if plane == nil {
            return
        }
        
        plane?.update(anchor: anchor as! ARPlaneAnchor)
    }
     
}

//MARK:- EXTENSION

extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- HANDLE SELECT BUTTON
    @objc fileprivate func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    //MARK:- IMAGE PICKER
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true, completion: nil)
        
        let filename = UUID().uuidString
        guard let userUID = user?.uid else { return }
        let ref = Storage.storage().reference(withPath: "/art/\(userUID)/\(filename)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 1) else {return}
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: view)
        ref.putData(uploadData, metadata: nil) { (nil, err) in
            hud.dismiss()
            if let err = err {
                print("Failed to upload image to storage: ", err)
                return
            }
            
            ref.downloadURL { (url, err) in
                hud.dismiss()
                if let err = err {
                    print("Failed to fetch download URL: ", err)
                    return
                }
                
                self.art?.imageUrl = url?.absoluteString
                self.art?.name = filename
                guard let artist = self.user?.fullName else {return}
                self.art?.artist = artist
                self.art?.forSale = true
                self.art?.sold = false
                
            }
        }
    }
}
