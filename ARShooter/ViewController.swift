//
//  ViewController.swift
//  ARShooter
//
//  Created by Macbook on 05/10/2017.
//  Copyright © 2017 Lodge Farm Apps. All rights reserved.
//


import UIKit
import ARKit

class ViewController: UIViewController {

	@IBOutlet weak var sceneView: ARSCNView!

	
	let configuration = ARWorldTrackingConfiguration()
	var power: Float = 50
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
		self.sceneView.session.run(configuration)
		self.sceneView.autoenablesDefaultLighting = true
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
		self.sceneView.addGestureRecognizer(gestureRecognizer)
		
	}
	
	@objc func handleTap(sender: UITapGestureRecognizer) {
		guard let sceneView = sender.view as? ARSCNView else {return}
		guard let pointOfView = sceneView.pointOfView else {return}
		
		let transform = pointOfView.transform
		let location = SCNVector3(transform.m41, transform.m42, transform.m43)
		let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
		let position = location + orientation
		let bullet = SCNNode(geometry: SCNSphere(radius: 0.1))
		bullet.geometry?.firstMaterial?.diffuse.contents = UIColor.red
		bullet.position = position
		let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: bullet, options: nil))
		body.isAffectedByGravity = false
		bullet.physicsBody = body
		bullet.physicsBody?.applyForce(SCNVector3(orientation.x*power, orientation.y*power, orientation.z*power), asImpulse: true)
		self.sceneView.scene.rootNode.addChildNode(bullet)
		
		
	}
	
	
	@IBAction func addTargets(_ sender: Any) {
		self.addEgg(x: 5, y: 0, z: -40)
		self.addEgg(x: 0, y: 0, z: -40)
		self.addEgg(x: -5, y: 0, z: -40)
		
	}
	
	func addEgg(x: Float, y: Float, z: Float) {
		let eggScene = SCNScene(named: "Models.scnassets/egg.scn")
		let eggNode = (eggScene?.rootNode.childNode(withName: "egg", recursively: false))!
		eggNode.position = SCNVector3(x,y,z)
		eggNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: eggNode, options: nil))
		self.sceneView.scene.rootNode.addChildNode(eggNode)
		
	}

}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
	return SCNVector3Make(left.x + right.x, left.y + left.y, left.z + right.z)
	
}

