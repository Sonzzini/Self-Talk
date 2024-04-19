//
//  OnboardingView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 15/04/24.
//

import SwiftUI

struct OnboardingView: View {
	
	@State var buttonIsPressed: Bool = false
	
	var body: some View {
		NavigationStack {
			Text("Seja bem vindo!")
			
			nextPageButton
		}
	}
}

#Preview {
	OnboardingView()
}

extension OnboardingView {
	private var nextPageButton: some View {
		Button {
			withAnimation(.easeInOut(duration: 0.2)) {
				buttonIsPressed.toggle()
				
				DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
					withAnimation(.easeInOut(duration: 1)) {
						buttonIsPressed.toggle()
					}
				}
			}
		} label: {
			Text("Next")
				.font(.title)
				.fontWeight(.semibold)
				.padding()
				.padding(.horizontal, 20)
				.foregroundStyle(.white)
				.background(buttonIsPressed ? Color.quinacridomeMagenta : Color.palatinate)
				.clipShape(RoundedRectangle(cornerRadius: 25))
		}
	}
}
