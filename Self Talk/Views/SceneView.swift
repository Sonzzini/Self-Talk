//
//  SceneView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 16/04/24.
//

import SwiftUI

struct SceneView: View {
	
	var scene: SceneModel
	
	var body: some View {
		NavigationStack {
			HStack {
				
				Spacer()
				
				VStack() {
					Text(scene.script)
						.font(.largeTitle)
						.fontWeight(.semibold)
				}
				
				Spacer()
				Divider()
				Spacer()
				
				VStack(alignment: .leading) {
					
				}
				
				Spacer()
			}
			
			.foregroundStyle(scene.color)
			.navigationTitle(scene.title)
			.navigationBarTitleDisplayMode(.large)
		}
	}
}

#Preview {
	SceneView(scene: SceneModel(color: .purple, title: "We sum good", script: "Wow script maneiro!"))
}
