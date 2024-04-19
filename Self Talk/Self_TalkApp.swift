//
//  Self_TalkApp.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 09/04/24.
//

import SwiftUI

@main
struct Self_TalkApp: App {
	
	@StateObject var viewModel = ViewModel()
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				  .environmentObject(viewModel)
        }
    }
}
