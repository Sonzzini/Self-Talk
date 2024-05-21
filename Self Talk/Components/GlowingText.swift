//
//  GlowingText.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 20/05/24.
//

import SwiftUI

struct GlowingText: View {
	let number: Int
	
	var body: some View {
		Text("\(number)")
			.font(.system(size: 100))
			.italic()
			.fontWeight(.bold)
			.foregroundColor(.white)
			.shadow(color: .blue, radius: 10, x: 0, y: 0)
			.shadow(color: .blue, radius: 10, x: 0, y: 0)
			.shadow(color: .blue, radius: 10, x: 0, y: 0)
	}
}


