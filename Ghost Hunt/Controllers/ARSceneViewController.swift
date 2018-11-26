//
//  ARSceneViewController.swift
//  Ghost Hunt
//
//  Created by Zachary Broeg on 11/21/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import UIKit
import ARKit

class ARSceneViewController: UIViewController, ARSCNViewDelegate {

    var sceneView: ARSCNView!
    var configuration: ARWorldTrackingConfiguration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = ARSCNView(frame: view.frame)
        view = sceneView
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ghost1Scene.scn")!
        sceneView.frame = view.frame
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        configuration = ARWorldTrackingConfiguration()
        if ARConfiguration.isSupported {
            // Run the view's session
            print("configuration supported")
            sceneView.session.run(configuration)
        } else {
            print("configuration not supported by device")
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    
     // Override to create and configure nodes for anchors added to the view's session.
    // func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
       
    
        
       /* let ghost1 = SCNNode
        let ghost2 = SCNNode()
        let ghost3 = SCNNode()
        let ghost4 = SCNNode()
        let ghost5 = SCNNode()
        
        var ghostArray : [SCNNode] = [ghost1, ghost2, ghost3, ghost4, ghost5]
       */
        // TODO: create the logic tree checking NSObject names and returning a corersponding node
        /*
         if( == true) {
            return ghost1
         } else if(){
         
         }
         checks to see which ghost is active
 */
     
       // return ghost1
    // }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("Session failed. Changing worldAlignment property.")
        print(error.localizedDescription)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

