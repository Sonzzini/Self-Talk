//
//  SceneCardsView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/04/24.
//

import SwiftUI

struct SceneCardsView: View {
	
	@EnvironmentObject var vm : ViewModel
	
	let row = [
		GridItem(.flexible(minimum: 200, maximum: 220)),
		GridItem(.flexible(minimum: 200, maximum: 220)),
		GridItem(.flexible(minimum: 200, maximum: 220)),
		GridItem(.flexible(minimum: 200, maximum: 220)),
		GridItem(.flexible(minimum: 200, maximum: 220))
	]
	
	@Binding var newScenarioSheetIsPresented: Bool
	
	@State var sceneFilter: String = ""
	
	var body: some View {
		NavigationStack {
			
			if vm.scenes.isEmpty {
				HStack {
					Text("Nenhuma cenário ainda!")
					Spacer()
				}
				.padding(.horizontal)
			}
			
			LazyVGrid(columns: row, spacing: 20) {
				ForEach(sceneFilter != "" ? vm.scenes.filter { $0.title!.lowercased().contains(sceneFilter.lowercased()) } : vm.scenes, id: \.id) { scene in
					NavigationLink {
						SceneView(scene: scene)
							.environmentObject(vm)
					} label: {
						SceneCard(scene: scene)
					}
				}
				
				newScenarioCardButton
			}
			
			
			
			
		}
		.padding(.horizontal)
		.frame(maxWidth: UIScreen.main.bounds.width)
		.searchable(text: $sceneFilter)
	}
}


//#Preview {
//	SceneCardsView(newScenarioSheetIsPresented: .constant(false))
//		.environmentObject(ViewModel(scenes: [
//			SceneModel(color: .blue, title: "1"),
//			SceneModel(color: .purple, title: "Wow!"),
//			SceneModel(color: .red, title: "Cenário!"),
//			SceneModel(color: .green, title: "Waba"),
//			SceneModel(color: .blue, title: "yahhoo"),
//			SceneModel(color: .blue, title: "yahhoo"),
//			SceneModel(color: .blue, title: "yahhoo"),
//			SceneModel(color: .blue, title: "yahhoo"),
//			SceneModel(color: .red, title: "yahhoo"),
//			SceneModel(color: .purple, title: "yahhoo"),
//			SceneModel(color: .green, title: "yahhoo"),
//			SceneModel(color: .green, title: "yahhoo"),
//			SceneModel(color: .red, title: "yahhoo")
//		])!)
//}

extension SceneCardsView {
	
	private var newScenarioCardButton: some View {
		Button {
			newScenarioSheetIsPresented.toggle()
		} label: {
			ZStack {
				Color.blue.opacity(0.3)
					.clipShape(RoundedRectangle(cornerRadius: 15))
				
				Image(systemName: "plus")
			}
			.frame(width: 200, height: 100)
		}
	}
	
}
