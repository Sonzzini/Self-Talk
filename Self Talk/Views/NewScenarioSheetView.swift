//
//  NewScenarioSheetView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/04/24.
//

import SwiftUI

struct NewScenarioSheetView: View {
	
	@EnvironmentObject var vm: ViewModel
	@Environment(\.dismiss) private var dismiss
	
	@State var scenarioTitle: String = ""
	@State var scenarioScript: String = ""
	
	@State var scenarioColor: Color = .white
	
	var body: some View {
		NavigationStack {
			Form {
				
				Section {
					TextField("", text: $scenarioTitle, prompt: Text("Título"))
				} header: {
					Text("Título")
				}
				
				Section {
					TextField("", text: $scenarioScript, prompt: Text("Script"), axis: .vertical)
						.lineLimit(5...10)
				} header: {
					Text("Informações adicionais")
				} footer: {
					Text("Ta poxa kkkkkk")
				}
				
				Section {
					ColorPicker("Cor de fundo", selection: $scenarioColor)
				}
				
			}
			
			ZStack(alignment: .topLeading) {
				scenarioColor
				Text(scenarioTitle)
					.padding()
			}
			.frame(width: 200, height: 100)
			.clipShape(RoundedRectangle(cornerRadius: 15))
			.border(Color.black)
			
			.navigationTitle("Novo cenário")
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					Button {
						vm.addScenario(
							with: SceneModel(color: scenarioColor,
												  title: scenarioTitle,
												  script: scenarioScript)
						)
						vm.getAllScenarios()
						dismiss()
					} label: {
						Image(systemName: "plus")
					}
				}
				
				ToolbarItem(placement: .cancellationAction) {
					Button {
						dismiss()
					} label: {
						Image(systemName: "trash")
							.foregroundStyle(.red)
					}
				}
			}
		}
	}
}

#Preview {
	NewScenarioSheetView()
		.environmentObject(ViewModel())
}
