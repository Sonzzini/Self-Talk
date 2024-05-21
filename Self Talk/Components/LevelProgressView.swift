//
//  LevelProgressView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 20/05/24.
//

import SwiftUI

struct LevelProgressView: View {
	 @Binding var currentLevel: Int
	 @Binding var currentXP: Int
	 @Binding var xpToAnimate: Int
	 
	 var body: some View {
		  HStack {
				Text("Nível \(currentLevel)")
					 .padding(.leading)
				
				ZStack(alignment: .leading) {
					 Rectangle()
						  .fill(Color.gray.opacity(0.3))
						  .frame(height: 10)
					 
					 Rectangle()
						  .fill(Color.green)
						  .frame(width: progressWidth(), height: 10)
						  .animation(.easeInOut, value: xpToAnimate)
				}
				
				Text("Nível \(currentLevel + 1)")
					 .padding(.trailing)
		  }
		  .frame(width: UIScreen.main.bounds.width * 0.8)  // Set the width to 80% of the screen width
	 }
	 
	 private func progressWidth() -> CGFloat {
		  let totalWidth = UIScreen.main.bounds.width * 0.8
		  let totalXPNeeded = xpForNextLevel(level: currentLevel)
		  let progress = CGFloat(xpToAnimate) / CGFloat(totalXPNeeded)
		  return totalWidth * progress
	 }
	 
	 private func xpForNextLevel(level: Int) -> Int {
		  // Example formula: XP required increases quadratically
		  return level * level * 100
	 }
}
