//
//  ScenesView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 15/04/24.
//

import SwiftUI
import CoreData

struct ScenesView: View {
	@EnvironmentObject var vm: ViewModel
	@State var searchField: String = ""
	
	@Environment(\.defaultMinListRowHeight) var rowHeight
	
	@State var viewBeingShown: views = .ListView
	
	@State var newScenarioSheetIsPresented: Bool = false
	
	@State var onboardingViewIsPresented: Bool = false
	
	@State var profileSheetIsPresented: Bool = false
	
	@Environment(\.managedObjectContext) private var moc
	
	var body: some View {
		NavigationStack {
			ScrollView {
				
				if viewBeingShown == .ListView {
					SceneCardsView(newScenarioSheetIsPresented: $newScenarioSheetIsPresented)
						.environmentObject(vm)
				}
				else if viewBeingShown == .ScriptView {
					ScriptsListView()
				}
				
			}
			.scrollDisabled(viewBeingShown == .ScriptView ? true : false)
			.navigationTitle(viewBeingShown == .ListView ? "Cenários" : "Scripts")
			.navigationBarTitleDisplayMode(.large)
			.searchable(text: $searchField)
			.onAppear {
				vm.getAllScenarios()
				
				// MARK: Se não houver usuário criado, crie
				if vm.getUserData() == 0 {
					onboardingViewIsPresented = true
					vm.createUserModel()
				}
				
			}
			
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
				
				ToolbarItem(placement: .cancellationAction) {
					Button {
						profileSheetIsPresented.toggle()
					} label: {
						Image(systemName: "person.fill")
					}
				}
			}
			.sheet(isPresented: $newScenarioSheetIsPresented) {
				NewScenarioSheetView()
					.interactiveDismissDisabled()
			}
			.sheet(isPresented: $onboardingViewIsPresented) {
				OnboardingView()
			}
			.sheet(isPresented: $profileSheetIsPresented) {
				ProfileView()
			}
		}
		
		
		
	}
}


//#Preview {
//	ScenesView()
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

extension ScenesView {
	
	
	
	
}


enum views {
	case ListView
	case ScriptView
}
