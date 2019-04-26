//
//  ARSceneViewController.swift
//  Ghost Hunt
//
//  Created by Zachary Broeg on 11/21/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

protocol ARGhostNodeDelegate {
    func getCurrentGhost() -> GhostModel
    func ghostCaptured()
}

class ARSceneViewController: UIViewController, ARSCNViewDelegate {

    //var sceneView: ARSCNView!   // ar scene view
    var sceneView: VirtualObjectARView! //** focus square scene view
    var ghostNode: SCNNode?    // ghost node in scene
    var button: SCNNode?    // ar button
    var uiMarker: SCNNode?   // ar ui marker
    var name: SCNNode?      // ar ui name
    var ghostModel: GhostModel!  // current ghost
    var ghostNodeDelegate: ARGhostNodeDelegate!
    var delegate: ARGhostNodeDelegate!
    var animations = [String : CAAnimation]()
    var idle:Bool = true
    var focusSquare = FocusSquare() //** creates the focus square
    var previousAnimation: String = "prev"
    var currentAnimation: String = "curr"
    
    let updateQueue = DispatchQueue(label: "com.example.apple-samplecode.arkitexample.serialSceneKitQueue")//** update queue
    
    var screenCenter: CGPoint { //**
        let bounds = sceneView.bounds
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    var session: ARSession { //**
        return sceneView.session
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        resetTracking()
    }
    
    // sets up ar scene view
    func setupView() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isHidden = false
        //TODO: On runtime this value equals nil so the app tries pushing to the camera but fails. 
        ghostModel = delegate.getCurrentGhost()
        loadAnimations()
        navigationItem.title = "\(ghostModel.ghostName)"
        sceneView = VirtualObjectARView()//ARSCNView(frame: view.frame)
        view = sceneView
        sceneView.scene.rootNode.addChildNode(focusSquare)
        sceneView.delegate = self
        sceneView.session.delegate = self
        setupCamera()
        sceneView.setupDirectionalLighting(queue: updateQueue)
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:)))  // tap gesture recognizer
        sceneView.addGestureRecognizer(tapRecognizer)
    }
    
    // configures ar world tracking
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .camera
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        
        if ARConfiguration.isSupported {
            print("configuration supported")
            sceneView.session.run(configuration)
        } else {
            print("configuration not supported by device")
        }
    }
    
    // Pause the view's session
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.navigationBar.isHidden = true
        sceneView.session.pause()
    }
    
    //**
    func setupCamera() {
        guard let camera = sceneView.pointOfView?.camera else {
            fatalError("Expected a valid `pointOfView` from the scene.")
        }
        camera.wantsHDR = true
        camera.exposureOffset = -1
        camera.minimumExposure = -1
        camera.maximumExposure = 3
    }
    
    //**
    func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        if #available(iOS 12.0, *) {
            configuration.environmentTexturing = .automatic
        }
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    //**
    func updateFocusSquare(isObjectVisible: Bool) {
        if isObjectVisible {
            focusSquare.hide()
        } else {
            focusSquare.unhide()
        }
        
        if let camera = session.currentFrame?.camera, case .normal = camera.trackingState,
            let result = self.sceneView.smartHitTest(screenCenter) {
            updateQueue.async {
                self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
                self.focusSquare.state = .detecting(hitTestResult: result, camera: camera)
            }
        } else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
        }
    }
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("renderer")
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        if (ghostNode == nil) {
            guard let ghostScene = SCNScene(named: "art.scnassets/\(self.ghostModel.ghostDirName)/\(self.ghostModel.fileName)"),
                let ghost = ghostScene.rootNode.childNode(withName: "ghost", recursively: true)
                else { return }
            uiMarker = ghost.childNode(withName: "ui marker", recursively: true)
            button = uiMarker!.childNode(withName: "button", recursively: true)
            let billboardConstraint = SCNBillboardConstraint()
            uiMarker?.constraints = [billboardConstraint]
            name = uiMarker?.childNode(withName: "name", recursively: true)
            if !self.ghostModel.locked {
                button?.isHidden = true
                name?.isHidden = false
                print("ghost not locked, key 2")
                //triggerAnimation(key: ghostModel.animationKeys[2])
            } else {
                //print("ghost locked, key 0")
                //previousAnimation = ghostModel.animationKeys[0]//"none"
                //triggerAnimation(key: ghostModel.animationKeys[0])
                //stopAnimation(key: currentAnimation)
                name?.isHidden = true
                button?.isHidden = false
            }
            ghost.position = SCNVector3(x,y - 1,z - 1)
            self.ghostNode = ghost
            node.addChildNode(ghost)
            //print("idk key 0")
            //triggerAnimation(key: ghostModel.animationKeys[0])
            focusSquare.isHidden = true
        }
    }
    
    func loadAnimations() {
        for i in 0...ghostModel.animationKeys.count - 1 {
            if ghostModel.animationKeys[i] != "none" {
                print("key: \(ghostModel.animationKeys[i]), File: \(ghostModel.animationFiles[i])")
                loadAnimation(withKey: ghostModel.animationKeys[i], sceneName: "art.scnassets/Animations/\(ghostModel.animationFiles[i])", animationIdentifier: "\(ghostModel.animationFiles[i])-1")
            }
        }
        /*for (key, value) in ghostModel.animationKeyToFile {
            print(key)
            animationKeys.append(key)
            if key != "none" {
                loadAnimation(withKey: key, sceneName: "art.scnassets/Animations/\(value)", animationIdentifier: "\(value)-1")
            }
        }*/
        
        //
        /*loadAnimation(withKey: "taunt", sceneName: "art.scnassets/Animations/TauntFixed", animationIdentifier: "TauntFixed-1")
        
        loadAnimation(withKey: "defeated", sceneName: "art.scnassets/Animations/DefeatedFixed", animationIdentifier: "DefeatedFixed-1")
        loadAnimation(withKey: "lookingaround", sceneName: "art.scnassets/Animations/LookingAroundFixed", animationIdentifier: "LookingAroundFixed-1")
        loadAnimation(withKey: "praying", sceneName: "art.scnassets/Animations/PrayingFixed", animationIdentifier: "PrayingFixed-1")*/
    }
    
    @objc func handleTap(tap: UITapGestureRecognizer){
        if tap.state == .ended {
            let location: CGPoint = tap.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if !hits.isEmpty {
                let tappedNode = hits.first?.node
                if (tappedNode?.name == "button") {
                    uiMarker?.isHidden = true
                    button?.isHidden = true
                    takeScreenshot()
                    self.delegate.ghostCaptured()
                    triggerAnimation(key: ghostModel.animationKeys[2])
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                        timer.invalidate()
                        //self.navigationController?.popViewController(animated: true)
                    }
                    print("screenshot, should be playing animation: " + currentAnimation)
                } else {
                    if let parentNode = tappedNode?.parent {
                        if (parentNode.name == "button") {
                            uiMarker?.isHidden = true
                            button?.isHidden = true
                            takeScreenshot()
                            self.delegate.ghostCaptured()
                            triggerAnimation(key: ghostModel.animationKeys[2])
                            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                                timer.invalidate()
                                //self.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            if (self.ghostModel.locked && idle) {
                                // locked and tapped animation while idle
                                print("locked tapped animation key 1")
                                triggerAnimation(key: ghostModel.animationKeys[1])
                            } else if (!self.ghostModel.locked && idle) {
                                // unlocked and tapped animation while idle
                                print("unlocked tapped animation key 3")
                                triggerAnimation(key: ghostModel.animationKeys[3])
                            } else if !self.ghostModel.locked && !idle {
                                print("key 2")
                                triggerAnimation(key: ghostModel.animationKeys[2])
                            } else {
                                triggerAnimation(key: ghostModel.animationKeys[0])
                                //previousAnimation = "none"
                                //stopAnimation(key: currentAnimation)
                                print("stop animation -> return to idle key 0")
                            }
                            //uiMarker?.isHidden.toggle()
                        }
                        idle = !idle
                    }
                }
                
            }
        }
    }
    
    func triggerAnimation(key: String) {
        print("triggered: " + key)
        currentAnimation = key
        if key != previousAnimation {
            print("changing from: \(previousAnimation) to: \(currentAnimation)")
            stopAnimation(key: previousAnimation)
            previousAnimation = currentAnimation
            playAnimation(key: currentAnimation)
        }
    }
    
    func loadAnimation(withKey: String, sceneName:String, animationIdentifier:String) {
        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        
        if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
            // The animation will only play once
            animationObject.repeatCount = 5
            // To create smooth transitions between animations
            animationObject.fadeInDuration = CGFloat(1)
            animationObject.fadeOutDuration = CGFloat(0.5)
            
            // Store the animation for later use
            animations[withKey] = animationObject
        }
    }
    
    func playAnimation(key: String) {
        // Add the animation to start playing it right away
        print(key)
        print("node: \(sceneView.scene.rootNode)")
        sceneView.scene.rootNode.addAnimation(animations[key]!, forKey: key)
    }
    
    func stopAnimation(key: String) {
        // Stop the animation with a smooth transition
        sceneView.scene.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
    }
    
    // Present an error message to the user
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("Session failed. Changing worldAlignment property.")
        print(error.localizedDescription)
    }
    
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    func sessionWasInterrupted(_ session: ARSession) {
        
    }
    
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    func sessionInterruptionEnded(_ session: ARSession) {
        
    }
    
    func takeScreenshot() {
        DispatchQueue.main.async {
            let flashOverlay = UIView(frame: self.sceneView.frame)
            flashOverlay.backgroundColor = UIColor.white
            self.sceneView.addSubview(flashOverlay)
            UIView.animate(withDuration: 0.5, animations: {
                flashOverlay.alpha = 0.0
            }, completion: { _ in
                flashOverlay.removeFromSuperview()
                let image = self.sceneView.snapshot()
                self.ghostModel.image = image
                self.ghostModel.locked = false
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                self.uiMarker?.isHidden = false
                self.name?.isHidden = false
            })
        }
        AudioServicesPlayAlertSound(1108)
    }
}

extension UIColor {
    open class var transparentLightBlue: UIColor {
        return UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.50)
    }
}
