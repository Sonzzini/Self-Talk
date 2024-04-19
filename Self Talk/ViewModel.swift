//
//  ViewModel.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 15/04/24.
//

import Foundation

class ViewModel: ObservableObject {
	@Published private var scenarioController: ScenarioController = ScenarioController()
	@Published var scenes: [SceneModel] = []
	
	init?(scenes: [SceneModel]) {
		for scene in scenes {
			addScenario(with: scene)
		}
	}
	
	init() {
		
	}
	
	func addScenario(with scene: SceneModel) {
		self.scenes.append(scene)
		self.scenarioController.addScenario(with: scene)
	}
	
	func getAllScenarios() -> [SceneModel] {
		return self.scenarioController.getAllScenarios()
	}
	
	
}
