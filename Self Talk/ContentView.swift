//
//  ContentView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 09/04/24.
//

import SwiftUI

struct ContentView: View {
	
	@EnvironmentObject var vm: ViewModel
	
	@State var onboardingViewIsPresented: Bool = true
	
	var body: some View {
		NavigationStack {
			
			NavigationLink {
				ScenesView()
			} label: {
				Label("Scenes", systemImage: "appwindow.swipe.rectangle")
			}
			
			NavigationLink {
				SpeechToTextView()
			} label: {
				Label("Speech to text", systemImage: "circle.fill")
			}

		}
		.sheet(isPresented: $onboardingViewIsPresented) {
			OnboardingView()
				.interactiveDismissDisabled()
		}
	}
}
//
//#Preview {
//	ContentView()
//		.environmentObject(ViewModel(scenes: [
//			SceneModel(color: .red, title: "Titulo 1")
//		])!)
//}
