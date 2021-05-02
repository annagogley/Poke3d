//
//  ViewController.swift
//  Poke3d
//
//  Created by Аня Воронцова on 27.04.2021.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        guard let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Cards", bundle: Bundle.main) else { return }
        
        configuration.detectionImages = imagesToTrack
        configuration.maximumNumberOfTrackedImages = 2
        print("Images succesfully added")
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        guard let imageAnchor = anchor as? ARImageAnchor else { return node }
        
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                             height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi/2
        node.addChildNode(planeNode)
        
        if imageAnchor.referenceImage.name == "idol" || imageAnchor.referenceImage.name == "blackSquare" {
            guard let msScene = SCNScene(named: "art.scnassets/moai.scn") else { return node}
            guard let msNode = msScene.rootNode.childNodes.first else { return node}
            msNode.scale = SCNVector3(0.00025, 0.00025, 0.00025)
            msNode.rotation = SCNVector4Make(0, 0, 0, .pi/2)
            planeNode.addChildNode(msNode)
        }
        
        if imageAnchor.referenceImage.name == "shark" || imageAnchor.referenceImage.name == "blueSquare" {
            guard let msScene = SCNScene(named: "art.scnassets/snorlax.scn") else { return node}
            guard let msNode = msScene.rootNode.childNodes.first else { return node}
                        msNode.scale = SCNVector3(0.0005, 0.0005, 0.0005)
            msNode.eulerAngles.x = .pi/2
            planeNode.addChildNode(msNode)
        }
        
        if imageAnchor.referenceImage.name == "redSquare" {
            guard let msScene = SCNScene(named: "art.scnassets/diceCollada.scn") else { return node}
            guard let msNode = msScene.rootNode.childNodes.first else { return node}
            msNode.scale = SCNVector3(0.5, 0.5, 0.5)
            msNode.eulerAngles.x = .pi/2
            planeNode.addChildNode(msNode)
        }
        
        return node
    }
    
}
