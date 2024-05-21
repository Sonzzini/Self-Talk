//
//  ProfileView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 20/05/24.
//

import SwiftUI

struct ProfileView: View {
	
	@EnvironmentObject var vm: ViewModel
	
	var body: some View {
		ScrollView {
			Image("Person")
				.resizable()
				.scaledToFit()
				.frame(width: 250, height: 250)
				.padding(.bottom, 50)
				.padding(.top, 150)
			
			Text("Level")
				.font(.largeTitle)
				.italic()
				.fontWeight(.bold)
				.foregroundStyle(Color.gray)
			
			if let user = vm.user.first {
				GlowingText(number: Int(user.level))
					.font(.system(size: 100))
					.italic()
					.fontWeight(.semibold)
					.foregroundStyle(Color.savoyBlue)
			}
			else {
				GlowingText(number: 1)
					.font(.system(size: 100))
					.italic()
					.fontWeight(.semibold)
					.foregroundStyle(Color.savoyBlue)
			}
		}
	}
}

#Preview {
	ProfileView()
}
