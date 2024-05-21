//
//  NewScenarioSheetView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/04/24.
//

import SwiftUI
import SwiftData

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
//					Text("Ta poxa kkkkkk")
				}
				
				Section {
					ColorPicker("Cor de fundo", selection: $scenarioColor)
				}
				
			}
			Text("Preview do card:")
				.font(.system(size: 25))
			
			ZStack(alignment: .topLeading) {
				scenarioColor
				Text(scenarioTitle != "" ? scenarioTitle : "Título")
					.padding()
			}
			.frame(width: 200, height: 100)
			.clipShape(RoundedRectangle(cornerRadius: 15))
			.border(scenarioColor == .white ? Color.black : Color.clear)
			
			.navigationTitle("Novo cenário")
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					addScenarioButton
				}
				
				ToolbarItem(placement: .cancellationAction) {
					dismissButton
				}
			}
		}
	}
}

#Preview {
	NewScenarioSheetView()
		.environmentObject(ViewModel())
}

extension NewScenarioSheetView {
	private var addScenarioButton: some View {
		Button {
			vm.addScenario(title: scenarioTitle,
								script: scenarioScript,
								color: scenarioColor.description)
			vm.getAllScenarios()
			dismiss()
		} label: {
			Image(systemName: "plus")
		}
	}
	
	private var dismissButton: some View {
		Button {
			dismiss()
		} label: {
			Image(systemName: "trash")
				.foregroundStyle(.red)
		}
	}
}
