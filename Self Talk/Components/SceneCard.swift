//
//  SceneCard.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 15/04/24.
//

import SwiftUI

struct SceneCard: View {
	
	var scene: SceneModel
	
	var body: some View {
		ZStack(alignment: .topLeading) {
			Color(scene.color)
				.frame(width: 200, height: 100)
				.clipShape(RoundedRectangle(cornerRadius: 15))
			
			Text(scene.title)
				.font(.headline)
				.foregroundStyle(.white)
				.padding()
		}
	}
}

#Preview {
	SceneCard(scene: SceneModel(color: .red, title: "Scene 1"))
}

