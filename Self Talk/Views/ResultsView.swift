//
//  ResultsView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 20/05/24.
//

import SwiftUI

struct ResultsView: View {
	
	@EnvironmentObject var vm: ViewModel
	
	@Environment(\.dismiss) private var dismiss
	@Binding var shouldDismiss: Bool
	
	var scriptText: String
	var patientText: String
	
	var scene: SceneModel
	
	@State private var resultText: Text = Text("")
	
	@State var currentLevel: Int = 0
	@State var currentXP: Int = 0
	@State var xpToAnimate: Int = 0
	
	var body: some View {
		NavigationStack {
			
			VStack {
				Text("RESULTADOS")
					.font(.largeTitle)
					.fontWeight(.bold)
					.italic()
					.navigationBarBackButtonHidden()
				
				LevelProgressView(currentLevel: $currentLevel, currentXP: $currentXP, xpToAnimate: $xpToAnimate)
				
				resultText
					.font(.title)
					.padding()
				
				Text("Nota: \(vm.calculateScore(script: scriptText, speech: patientText))/100")
					.font(.largeTitle)
					.padding()
				
				Spacer()
			}
			.onAppear {
				compareText(script: scriptText, speech: patientText)
				currentLevel = Int(vm.user[0].level)
				currentXP = Int(vm.user[0].xp)
				
				let score = vm.calculateScore(script: scriptText, speech: patientText)
				addXP(basedOn: score)
				vm.addXP(basedOn: score)
				
				vm.createSceneResult(for: scene, with: Float(score))
			}
			
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button {
						dismiss()
						shouldDismiss = true
					} label: {
						HStack {
							Image(systemName: "chevron.left")
							Text("Back")
						}
						.foregroundStyle(Color.accentColor)
					}
				}
			}
			
		}
	}
	
	func compareText(script: String, speech: String) {
		let scriptWords = script.split(separator: " ").map { String($0) }
		let speechWords = speech.split(separator: " ").map { String($0) }
		
		var result = Text("")
		var usedScriptWords = Set<Int>()
		
		for speechWord in speechWords {
			if let (bestMatchIndex, _) = scriptWords.enumerated().min(by: { vm.levenshtein($0.element, speechWord) < vm.levenshtein($1.element, speechWord) }) {
				if !usedScriptWords.contains(bestMatchIndex) && vm.levenshtein(scriptWords[bestMatchIndex], speechWord) <= 2 {
					result = result + Text(" \(speechWord)").foregroundColor(.green)
					usedScriptWords.insert(bestMatchIndex)
				} else {
					result = result + Text(" \(speechWord)").foregroundColor(.red)
				}
			} else {
				result = result + Text(" \(speechWord)").foregroundColor(.red)
			}
		}
		
		DispatchQueue.main.async {
			self.resultText = result
		}
	}
	
	func xpForNextLevel(level: Int) -> Int {
		// Example formula: XP required increases quadratically
		return level * level * 100
	}
	
	func addXP(basedOn score: Int) {
		let xpEarned = score
		xpToAnimate = 0
		let totalXPNeeded = xpForNextLevel(level: currentLevel)
		
		if currentXP + xpEarned >= totalXPNeeded {
			let remainingXP = xpEarned - (totalXPNeeded - currentXP)
			currentXP = totalXPNeeded
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				withAnimation(.linear(duration: 1.0)) {
					self.xpToAnimate = self.currentXP
				}
				DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
					self.currentXP = 0
					self.currentLevel += 1
					withAnimation(.linear(duration: 1.0)) {
						self.xpToAnimate = remainingXP
					}
					self.currentXP += remainingXP
				}
			}
		} else {
			currentXP += xpEarned
			withAnimation(.linear(duration: 1.0)) {
				xpToAnimate = currentXP
			}
		}
	}
}


