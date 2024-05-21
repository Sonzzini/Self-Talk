//
//  ARView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 17/05/24.
//

import Foundation
import SwiftUI
import ARKit
import SceneKit

struct ARView: UIViewRepresentable {
	func makeUIView(context: Context) -> ARSCNView {
		let arView = ARSCNView(frame: .zero)
		let configuration = ARWorldTrackingConfiguration()
		configuration.planeDetection = [.horizontal, .vertical]
		arView.session.run(configuration)
		arView.autoenablesDefaultLighting = true
		return arView
	}
	
	func updateUIView(_ uiView: ARSCNView, context: Context) {
		// Update the view during SwiftUI State changes
	}
	
	static func dismantleUIView(_ uiView: ARSCNView, coordinator: ()) {
		uiView.session.pause()
	}
}
