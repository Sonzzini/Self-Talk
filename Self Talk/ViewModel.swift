//
//  ViewModel.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 15/04/24.
//

import Foundation
import CoreData
import SwiftUI

class ViewModel: ObservableObject {
	@Published var scenes: [SceneModel] = []
	@Published var user: [UserEntity] = []
	@Published var sceneResults: [SceneResult] = []
	@Published var context: NSManagedObjectContext
	
	init() {
		self.context = DataController.shared.viewContext
	}
	
	func addScenario(title: String, script: String, color: String) {
		let model = SceneModel(context: context)
		model.title = title
		model.color = color
		model.script = script
		model.evaluation = -1
		self.scenes.append(model)
		do {
			try context.save()
		} catch {
			print("Error saving model of name: \(model.title ?? "MODEL_TITLE"), error: \(error)")
		}
	}
	
	func createUserModel() {
		let user = UserEntity(context: context)
		user.firstLogin = false
		user.firstScenario = true
		user.level = 1
		user.xp = 0
		do {
			try context.save()
		} catch {
			print("Error saving user data: \(error)")
		}
	}
	
	func createSceneResult(for scene: SceneModel, with score: Float) {
		let result = SceneResult(context: context)
		result.sceneID = scene.id?.uuidString
		result.evaluation = score
		result.data = Date.now
		do {
			try context.save()
		} catch {
			print("Error saving scene result with ID: \(scene.id?.uuidString ?? "SCENE_UUID"), ERROR: \(error)")
		}
	}
	
	// MARK: Se retornar 0 -> Usuário ainda não foi criado
	// MARK: Se retornar 1 -> Usuário já foi criado
	func getUserData() -> Int {
		self.user = DataController.shared.getAllUserEntities()
		return user.count
	}
	
	func getAllScenarios() {
		self.scenes = DataController.shared.getAllScenes()
	}
	
	func getAllResults() {
		self.sceneResults = DataController.shared.getAllSceneResults()
	}
	
	func deleteScenario(scene: SceneModel) {
		DataController.shared.deleteScenario(scene: scene)
	}
	
	func getColor(scene: SceneModel) -> Color {
		return Color(description: scene.color ?? "")
	}
	
	func splitStringIntoChunks(_ input: String, wordsPerChunk: Int)  -> [String] {
		let words = input.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
		var chunks: [String] = []
		
		for index in stride(from: 0, to: words.count, by: wordsPerChunk) {
			let chunk = words[index..<min(index + wordsPerChunk, words.count)]
			chunks.append(chunk.joined(separator: " "))
		}
		
		return chunks
	}
	
	func levenshtein(_ aStr: String, _ bStr: String) -> Int {
		let a = Array(aStr)
		let b = Array(bStr)
		let m = a.count
		let n = b.count
		
		var distance = [[Int]](repeating: [Int](repeating: 0, count: n + 1), count: m + 1)
		
		for i in 0...m { distance[i][0] = i }
		for j in 0...n { distance[0][j] = j }
		
		for i in 1...m {
			for j in 1...n {
				if a[i - 1] == b[j - 1] {
					distance[i][j] = distance[i - 1][j - 1]
				} else {
					distance[i][j] = min(distance[i - 1][j - 1] + 1,
												distance[i][j - 1] + 1,
												distance[i - 1][j] + 1)
				}
			}
		}
		
		return distance[m][n]
	}
	
	
	func compareText(script: String, speech: String) -> Text {
		let scriptWords = script.split(separator: " ").map { String($0) }
		let speechWords = speech.split(separator: " ").map { String($0) }
		
		var result = Text("")
		
		let maxCount = max(scriptWords.count, speechWords.count)
		let threshold = 10  // Allowable number of differences
		
		for i in 0..<maxCount {
			if i < scriptWords.count && i < speechWords.count {
				if scriptWords[i] == speechWords[i] || levenshtein(scriptWords[i], speechWords[i]) <= threshold {
					result = result + Text(" \(scriptWords[i])").foregroundColor(.green)
				} else {
					result = result + Text(" \(speechWords[i])").foregroundColor(.red)
				}
			} else if i < scriptWords.count {
				result = result + Text(" \(scriptWords[i])").foregroundColor(.red)
			} else if i < speechWords.count {
				result = result + Text(" \(speechWords[i])").foregroundColor(.red)
			}
		}
		
		return result
	}
	
	func calculateScore(script: String, speech: String) -> Int {
		let scriptWords = script.split(separator: " ").map { String($0) }
		let speechWords = speech.split(separator: " ").map { String($0) }
		
		var correctCount = 0
		var usedScriptWords = Set<Int>()
		
		for speechWord in speechWords {
			if let (bestMatchIndex, _) = scriptWords.enumerated().min(by: { levenshtein($0.element, speechWord) < levenshtein($1.element, speechWord) }) {
				if !usedScriptWords.contains(bestMatchIndex) && levenshtein(scriptWords[bestMatchIndex], speechWord) <= 2 {
					correctCount += 1
					usedScriptWords.insert(bestMatchIndex)
				}
			}
		}
		
		let score = (Double(correctCount) / Double(scriptWords.count)) * 100
		return Int(score)
	}
	
	func xpForNextLevel(level: Int) -> Int {
		// Example formula: XP required increases quadratically
		return level * level * 100
	}
	
	func addXP(basedOn score: Int) {
		let xpEarned = score
		user[0].xp += Float(xpEarned)
		
		// Check if the user has enough XP to level up
		while Int(user[0].xp) >= xpForNextLevel(level: Int(user[0].level)) {
			user[0].xp -= Float(xpForNextLevel(level: Int(user[0].level)))
			user[0].level += 1
		}
		do {
			try context.save()
			print("CurrentLevel: \(user[0].level)")
			print("CurrentXP: \(user[0].xp)")
		} catch {
			print("ERROR adding XP: \(error)")
		}
	}
	
	
	
}
