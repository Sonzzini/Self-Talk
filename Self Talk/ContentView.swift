//
//  ContentView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 09/04/24.
//

import SwiftUI

struct ContentView: View {
	
	@EnvironmentObject var vm: ViewModel
	
	var body: some View {
		NavigationStack {
			NavigationLink {
				ScenesView()
			} label: {
				Label("Scenes", systemImage: "appwindow.swipe.rectangle")
			}

		}
	}
}

#Preview {
	ContentView()
		.environmentObject(ViewModel(scenes: [
			SceneModel(color: .red, title: "Titulo 1")
		])!)
}
