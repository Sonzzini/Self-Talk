//
//  ARViewWithGuy.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 20/05/24.
//

import Foundation
import SwiftUI
import ARKit

struct ARViewWithGuy: UIViewRepresentable {
	 func makeUIView(context: Context) -> ARSCNView {
		  let arView = ARSCNView(frame: .zero)
		  let configuration = ARWorldTrackingConfiguration()
		  configuration.planeDetection = [.horizontal, .vertical]
		  arView.session.run(configuration)
		  arView.autoenablesDefaultLighting = true

		  // Add 3D model to the scene
		  let scene = SCNScene()
		  arView.scene = scene
		  add3DModel(to: scene)

		  return arView
	 }

	 func updateUIView(_ uiView: ARSCNView, context: Context) {
		  // Update the view during SwiftUI State changes
	 }

	 static func dismantleUIView(_ uiView: ARSCNView, coordinator: ()) {
		  uiView.session.pause()
	 }

	 private func add3DModel(to scene: SCNScene) {
		  // Create a cylinder for the body
		  let cylinder = SCNCylinder(radius: 0.1, height: 0.5)
		  let cylinderNode = SCNNode(geometry: cylinder)
		  cylinderNode.position = SCNVector3(0, 0.25, -1) // Adjust position as needed

		  // Create a sphere for the head
		  let sphere = SCNSphere(radius: 0.1)
		  let sphereNode = SCNNode(geometry: sphere)
		  sphereNode.position = SCNVector3(0, 0.6, -1) // Position above the cylinder

		  // Add nodes to the scene
		  scene.rootNode.addChildNode(cylinderNode)
		  scene.rootNode.addChildNode(sphereNode)
	 }
}
