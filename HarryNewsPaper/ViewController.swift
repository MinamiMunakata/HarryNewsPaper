//
//  ViewController.swift
//  HarryNewsPaper
//
//  Created by minami on 2018-11-22.
//  Copyright © 2018 宗像三奈美. All rights reserved.
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
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Create a session configuration -> change `world` to `image`
    let configuration = ARImageTrackingConfiguration()
    if let trackImage = ARReferenceImage.referenceImages(inGroupNamed: "NewsImages", bundle: Bundle.main) {
      configuration.trackingImages = trackImage
      configuration.maximumNumberOfTrackedImages = 1
    }
    
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
    // node <- plane <- videoScene
    if let imageAnchor = anchor as? ARImageAnchor {
      let videoNode = SKVideoNode(fileNamed: "harrypotter.mp4")
      videoNode.play()
      
      // 360p -> w:480 h:360, 720p -> w:1080 h:720
      let videoScene = SKScene(size: CGSize(width: 480, height: 360))
      videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
      videoNode.yScale = -1.0
      videoScene.addChild(videoNode)
      
      let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                           height: imageAnchor.referenceImage.physicalSize.height)
//      plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
      plane.firstMaterial?.diffuse.contents = videoScene
      let planeNode = SCNNode(geometry: plane)
      planeNode.eulerAngles.x = -.pi / 2
      node.addChildNode(planeNode)
    }
    
    return node
  }
  
}
