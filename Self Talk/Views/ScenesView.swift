//
//  ScenesView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 15/04/24.
//

import SwiftUI

struct ScenesView: View {
	@EnvironmentObject var vm: ViewModel
	@State var searchField: String = ""
	
	@Environment(\.defaultMinListRowHeight) var rowHeight
	
	@State var viewBeingShown: views = .ListView
	
	@State var newScenarioSheetIsPresented: Bool = false
	
	
	var body: some View {
		NavigationStack {
			ScrollView {
				
				if viewBeingShown == .ListView {
					SceneCardsView(newScenarioSheetIsPresented: $newScenarioSheetIsPresented)
				}
				else if viewBeingShown == .ScriptView {
					ScriptsListView()
				}
				
			}
			.scrollDisabled(viewBeingShown == .ScriptView ? true : false)
			.navigationTitle(viewBeingShown == .ListView ? "Cenários" : "Scripts")
			.navigationBarTitleDisplayMode(.large)
			.searchable(text: $searchField)
			
			.toolbar {
				ToolbarItem(placement: .automatic) {
					Button {
						withAnimation(.easeInOut(duration: 0.3)) {
							if viewBeingShown == .ListView {
								viewBeingShown = .ScriptView
							} else {
								viewBeingShown = .ListView
							}
						}
					} label: {
						Label("Scripts", systemImage: "rectangle.and.text.magnifyingglass")
					}
				}
			}
			.sheet(isPresented: $newScenarioSheetIsPresented) {
				NewScenarioSheetView()
					.interactiveDismissDisabled()
			}
		}
		
		
		
	}
}


#Preview {
	ScenesView()
		.environmentObject(ViewModel(scenes: [
			SceneModel(color: .blue, title: "1"),
			SceneModel(color: .purple, title: "Wow!"),
			SceneModel(color: .red, title: "Cenário!"),
			SceneModel(color: .green, title: "Waba"),
			SceneModel(color: .blue, title: "yahhoo"),
			SceneModel(color: .blue, title: "yahhoo"),
			SceneModel(color: .blue, title: "yahhoo"),
			SceneModel(color: .blue, title: "yahhoo"),
			SceneModel(color: .red, title: "yahhoo"),
			SceneModel(color: .purple, title: "yahhoo"),
			SceneModel(color: .green, title: "yahhoo"),
			SceneModel(color: .green, title: "yahhoo"),
			SceneModel(color: .red, title: "yahhoo")
		])!)
}

extension ScenesView {
	

	
	
}


enum views {
	case ListView
	case ScriptView
}
