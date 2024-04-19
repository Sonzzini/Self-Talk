//
//  SceneModel.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 15/04/24.
//

import Foundation
import SwiftData
import SwiftUI


//@Model
class SceneModel: Hashable {
	
	
	
	let id = UUID()
	var color: Color
	var title: String
	var script: String
	
	init(color: Color, title: String, script: String = "") {
		self.color = color
		self.title = title
		self.script = script
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	static func == (lhs: SceneModel, rhs: SceneModel) -> Bool {
		return lhs.id == rhs.id
	}
}



enum colorSet {
	case red
	case purple
	case blue
	case green
	
	var value: Color {
		switch self {
		case .red:
			return Color.quinacridomeMagenta
		case .purple:
			return Color.palatinate
		case .blue:
			return Color.savoyBlue
		case .green:
			return Color.green
		}
	}
}
