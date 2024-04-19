//
//  ScenarioController.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/04/24.
//

import Foundation

class ScenarioController: ObservableObject {
	@Published var scenes: [SceneModel] = []
	
	func addScenario(with scene: SceneModel) {
		self.scenes.append(scene)
	}
	
	func getAllScenarios() -> [SceneModel] {
		return self.scenes
	}
}
