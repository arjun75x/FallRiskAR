//
//  VisionViewController.swift
//  FallRiskAR
//
//  Created by Arjun Arun on 12/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreMedia

class VisionViewController: UIViewController {
  @IBOutlet var sceneView: ARSCNView!
  @IBOutlet weak var instructionLabel: UILabel!

  private var worldConfiguration: ARWorldTrackingConfiguration?

  lazy var audioSource: SCNAudioSource = {
    let source = SCNAudioSource(fileNamed: "detect.wav")!
    source.loops = false
    source.load()
    return source
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    sceneView.delegate = self

    //sceneView.showsStatistics = true

    let scene = SCNScene()
    sceneView.scene = scene

    setupObjectDetection()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let configuration = worldConfiguration {
      sceneView.debugOptions = .showFeaturePoints
      sceneView.session.run(configuration)
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    sceneView.session.pause()
  }

  private func setupObjectDetection() {
    worldConfiguration = ARWorldTrackingConfiguration()

    guard let referenceObjects = ARReferenceObject.referenceObjects(
      inGroupNamed: "AR Resources", bundle: nil) else {
        fatalError("Missing expected asset catalog resources.")
    }

    worldConfiguration?.detectionObjects = referenceObjects

  }

}

extension VisionViewController: ARSessionDelegate {
  func session(_ session: ARSession, didFailWithError error: Error) {
    guard
      let error = error as? ARError,
      let code = ARError.Code(rawValue: error.errorCode)
      else { return }
    instructionLabel.isHidden = false
    switch code {
    case .cameraUnauthorized:
      instructionLabel.text = "Camera tracking is not available. Please check your camera permissions."
    default:
      instructionLabel.text = "Error starting ARKit. Please fix the app and relaunch."
    }
  }

  func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    switch camera.trackingState {
    case .limited(let reason):
      instructionLabel.isHidden = false
      switch reason {
      case .excessiveMotion:
        instructionLabel.text = "Excessive Motion"
      case .initializing, .relocalizing:
        instructionLabel.text = "Initializing ARKit"
      case .insufficientFeatures:
        instructionLabel.text = "Insufficient Features Detected"
      }
    case .normal:
      instructionLabel.text = "Point at objects to analyze Fall Risk"
    case .notAvailable:
      instructionLabel.isHidden = false
      instructionLabel.text = "Camera unavailable"
    }
  }
}

extension VisionViewController: ARSCNViewDelegate {
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    DispatchQueue.main.async { self.instructionLabel.isHidden = true }
    if let objectAnchor = anchor as? ARObjectAnchor {
      handleFoundObject(objectAnchor, node)
    }
  }


  private func handleFoundObject(_ objectAnchor: ARObjectAnchor, _ node: SCNNode) {
    let name = objectAnchor.referenceObject.name!
    print("Found \(name) object")

    if let object = Risk.getObject(for: name) {
      mainInstance.add(risk: object)
      let titleNode = createTitleNode(info: object)
      node.addChildNode(titleNode)
      
      let riskNode = createRiskNode(risk_level: "Risk Level: " + object.level)
      node.addChildNode(riskNode)
    }

    node.addAudioPlayer(SCNAudioPlayer(source: audioSource))
  }

  private func createTitleNode(info: Risk) -> SCNNode {
    let title = SCNText(string: info.name, extrusionDepth: 0.7)
    let titleNode = SCNNode(geometry: title)
    titleNode.scale = SCNVector3(0.005, 0.005, 0.01)
    titleNode.position = SCNVector3(0.02, 0.05, 0)
    
    // 3
    let billboardConstraints = SCNBillboardConstraint()
    titleNode.constraints = [billboardConstraints]
    return titleNode
  }

  private func createRiskNode(risk_level: String) -> SCNNode {
    // 1
    let textGeometry = SCNText(string: risk_level, extrusionDepth: 0.7)
    let textNode = SCNNode(geometry: textGeometry)
    textNode.scale = SCNVector3(0.003, 0.003, 0.01)
    textNode.position = SCNVector3(0.02, 0.00, 0)

    // 2
    let material = SCNMaterial()
    material.diffuse.contents = UIColor.blue
    textGeometry.materials = [material]

    // 3
    let billboardConstraints = SCNBillboardConstraint()
    textNode.constraints = [billboardConstraints]
    return textNode
  }
}

