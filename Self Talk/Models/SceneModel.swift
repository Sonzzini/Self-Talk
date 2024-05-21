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
//class SceneModel: Hashable {
//	
//	let id = UUID()
//	var color: String
//	var title: String
//	var script: String
//	
//	init(color: String, title: String, script: String = "") {
//		self.color = color
//		self.title = title
//		self.script = script
//	}
//	
//	func hash(into hasher: inout Hasher) {
//		hasher.combine(id)
//	}
//	static func == (lhs: SceneModel, rhs: SceneModel) -> Bool {
//		return lhs.id == rhs.id
//	}
//	
//	func getColor() -> Color {
//		return Color(description: self.color)
//	}
//}



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


extension Color {
	 // Initialize color from a string description
	 init(description: String) {
		  let components = description.components(separatedBy: " ")
		  // Expecting format like "sRGB 0.123 0.456 0.789 1.0"
		  if components.count >= 5,
			  let r = Double(components[1]),
			  let g = Double(components[2]),
			  let b = Double(components[3]),
			  let o = Double(components[4]) {
				self.init(.sRGB, red: r, green: g, blue: b, opacity: o)
		  } else {
				// Default color if parsing fails
				self.init(.sRGB, red: 1, green: 0, blue: 0, opacity: 1) // Default to red color
		  }
	 }
}
