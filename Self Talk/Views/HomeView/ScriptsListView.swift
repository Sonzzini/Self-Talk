//
//  ScriptsListView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/04/24.
//

import SwiftUI

struct ScriptsListView: View {
	
	@EnvironmentObject var vm : ViewModel
	@Environment(\.defaultMinListRowHeight) var rowHeight
	
	@State var scenarioFilter: String = ""
	
	var body: some View {
		NavigationStack {
			List {
				if !vm.scenes.isEmpty {
					ForEach(scenarioFilter != "" ?
							  vm.scenes.filter { $0.title!.lowercased().contains(scenarioFilter.lowercased()) }
							  : vm.scenes, id: \.id) { scene in
						NavigationLink {
							SceneView(scene: scene)
						} label: {
							Text(scene.title ?? "SCENE_TITLE")
						}
					}
				}
				else {
					Text("Nenhum cenário ainda!")
				}
			}
			.listStyle(.grouped)
			.frame(height: rowHeight * CGFloat(vm.scenes.count) + 2 * rowHeight)
			.searchable(text: $scenarioFilter)
		}
	}
}


//#Preview {
//	ScriptsListView()
//		.environmentObject(ViewModel(scenes: [SceneModel(color: .red, title: "buga buga", script: "iga iga")])!)
//}
