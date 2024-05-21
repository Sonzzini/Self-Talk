//
//  DataController.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 17/05/24.
//

import Foundation
import CoreData

class DataController: ObservableObject {
	
	static let shared = DataController()
	let persistentContainer: NSPersistentContainer
	
	var viewContext: NSManagedObjectContext {
		return persistentContainer.viewContext
	}
	
	init(){
		persistentContainer = NSPersistentContainer(name: "Models")
		
		persistentContainer.loadPersistentStores { description, error in
			if let error = error {
				print("Core Data failed to load: \(error.localizedDescription)")
			}
		}
	}
	
	func getAllScenes() -> [SceneModel] {
		let request = NSFetchRequest<SceneModel>(entityName: "SceneModel")
		
		do {
			return try viewContext.fetch(request)
		} catch {
			return []
		}
	}
	
	func deleteScenario(scene: SceneModel) {
		viewContext.delete(scene)
		try? viewContext.save()
	}
	
	func getAllUserEntities() -> [UserEntity] {
		let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
		
		do {
			return try viewContext.fetch(request)
		} catch {
			return []
		}
	}
	
	func getAllSceneResults() -> [SceneResult] {
		let request = NSFetchRequest<SceneResult>(entityName: "SceneResult")
		
		do {
			return try viewContext.fetch(request)
		} catch {
			return []
		}
	}
	
}
