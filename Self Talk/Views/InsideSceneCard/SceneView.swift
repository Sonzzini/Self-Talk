//
//  SceneView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 16/04/24.
//
import Foundation
import SwiftUI

struct SceneView: View {
	
	@EnvironmentObject var vm: ViewModel
	@Environment(\.dismiss) private var dismiss
	
	var scene: SceneModel
	
	@State var isEditing: Bool = false
	
	@State var script: String = ""
	@State var scriptBackup: String = ""
	
	@State var newColor: Color = .white
	@State var colorBackup: Color = .white
	@State var canChangeColor: Bool = false
	
	@State var newText: String = ""
	@State var textBackup: String = ""
	
	@State var showingAlert: Bool = false
	
	@State var previousSceneResults: [SceneResult] = []
	
	let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd/MM/yy"
		return formatter
	}()
	
	var body: some View {
		NavigationStack {
			
			if isEditing {
				TextEditor(text: $newText)
					.font(.largeTitle)
					.fontWeight(.semibold)
					.frame(height: UIScreen.main.bounds.height * 0.2)
			}
			
			HStack {
				
				Spacer()
				
				VStack(alignment: .leading) {
					
					Text("Script")
						.font(.largeTitle)
						.fontWeight(.semibold)
						.foregroundStyle(.secondary)
					
					Spacer()
					
					if !isEditing {
						Text(script)
							.font(.title)
							.fontWeight(.semibold)
							.frame(width: UIScreen.main.bounds.width * 0.7)
					}
					else if isEditing {
						TextEditor(text: $script)
							.font(.title)
							.fontWeight(.semibold)
							.textFieldStyle(DefaultTextFieldStyle())
					}
					
					Spacer()
				}
				
				Spacer()
				Spacer()
				Divider()
				Spacer()
				
				VStack {
					Text("Últimas avaliações")
						.font(.title)
						.fontWeight(.semibold)
					
					if previousSceneResults.isEmpty {
						Text("Nenhuma avaliação feita ainda")
							.foregroundStyle(.secondary)
					} else {
						HStack {
							
							VStack(alignment:.center) {
								Text("Nota")
								ForEach(previousSceneResults, id: \.id) { result in
									Text("\(Int(result.evaluation))")
										.foregroundStyle(newColor)
								}
							}
							.padding(.trailing, 50)
							
							VStack(alignment:.center) {
								Text("Data")
								ForEach(previousSceneResults, id: \.id) { result in
									Text("\(dateFormatter.string(from: result.data ?? Date.now))")
										.foregroundStyle(newColor)
								}
							}
						}
						.foregroundStyle(.secondary)
						
						
					}
					
					Spacer()
					
					if !isEditing {
						getStartedNavigationButton
					}
				}
				
				Spacer()
			}
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					if isEditing {
						ColorPicker("Cor de fundo", selection: $newColor)
							.onChange(of: newColor) { oldValue, newValue in
								canChangeColor = true
							}
					}
				}
				
				ToolbarItemGroup(placement: .destructiveAction) {
					HStack {
						if !isEditing {
							exportPDFButton
						}
						
						editButton
						
						cancelEditButton
						
						if isEditing {
							deleteSceneButton
						}
					}
				}
			}
			.onAppear {
				script = scene.script ?? "SCENE_SCRIPT"
				scriptBackup = scene.script ?? "SCENE_SCRIPT_BACKUP"
				
				newColor = vm.getColor(scene: scene)
				colorBackup = vm.getColor(scene: scene)
				
				newText = scene.title ?? "SCENE_TITLE"
				textBackup = scene.title ?? "SCENE_TITLE_BACKUP"
				
				vm.getAllResults()
				previousSceneResults = vm.sceneResults.filter { $0.sceneID == scene.id?.uuidString }
			}
			
			.alert("Tem certeza que deseja excluir este cenário?", isPresented: $showingAlert) {
				Button("Sim", role: .destructive) { vm.deleteScenario(scene: scene); dismiss() }
				Button("Cancelar", role: .cancel) {  }
			}
			
			.foregroundStyle(newColor)
			.navigationTitle(isEditing ? "" : scene.title ?? "SCENE_TITLE")
			.navigationBarTitleDisplayMode(.large)
		}
	}
}
//
//#Preview {
//	SceneView(scene: SceneModel(color: .purple, title: "We sum good", script: "Wow script maneiro!"))
//}

extension SceneView {
	
	private var editButton: some View {
		Button {
			withAnimation(.spring()) {
				if isEditing {
					scene.script = script
					if canChangeColor {
						scene.color = newColor.description
					}
					scene.title = newText
					do {
						try vm.context.save()
					} catch {
						print("Error updating SCENE_SCRIPT: \(error)")
					}
				}
				isEditing.toggle()
			}
		} label: {
			Text(isEditing ? "Save" : "Edit")
		}
	}
	
	private var cancelEditButton: some View {
		Button {
			script = scriptBackup
			newColor = colorBackup
			newText = textBackup
			withAnimation(.spring()) {
				isEditing.toggle()
			}
		} label: {
			Text(isEditing ? "Cancel" : "")
		}
	}
	
	private var deleteSceneButton: some View {
		Button(role: .destructive) {
			showingAlert.toggle()
		} label: {
			Text("Deletar cenário")
				.foregroundStyle(.red)
		}
	}
	
	private var getStartedNavigationButton: some View {
		NavigationLink {
			ARContainerView(scene: scene)
		} label: {
			Text("Começar")
				.padding()
				.padding(.horizontal)
				.background(newColor)
				.clipShape(RoundedRectangle(cornerRadius: 8))
				.foregroundStyle(.white)
				.fontWeight(.semibold)
		}
	}
	
	private var exportPDFButton: some View {
		Button {
			exportToPDF()
		} label: {
			Image(systemName: "square.and.arrow.up")
		}
	}
	
	
	func exportToPDF() {
		guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
				let rootVC = windowScene.windows.first?.rootViewController else {
			print("Unable to access root view controller.")
			return
		}
		
		// Crie uma instância do UIHostingController com a ContentView e passe o EnvironmentObject
		let hostingController = UIHostingController(rootView: self.environmentObject(ViewModel()))
		
		rootVC.addChild(hostingController)
		hostingController.view.frame = rootVC.view.bounds
		rootVC.view.addSubview(hostingController.view)
		
		// Gerar dados do PDF
		let pdfData = hostingController.view.asPDF()
		
		// Criar um arquivo temporário
		let fileName = "\(scene.title ?? "Scene") Results.pdf"
		let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
		
		do {
			try pdfData.write(to: tempURL)
		} catch {
			print("Failed to write PDF data to temporary file: \(error)")
			return
		}
		
		// Criar e apresentar o UIActivityViewController
		let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
		
		// Configurar sourceView para iPad
		if let popoverController = activityVC.popoverPresentationController {
			popoverController.sourceView = hostingController.view
			popoverController.sourceRect = CGRect(x: hostingController.view.bounds.midX, y: hostingController.view.bounds.midY, width: 0, height: 0)
			popoverController.permittedArrowDirections = []
		}
		
		rootVC.present(activityVC, animated: true, completion: nil)
		
		hostingController.view.removeFromSuperview()
		hostingController.removeFromParent()
	}
}


extension UIView {
	func asPDF() -> Data {
		let pdfRenderer = UIGraphicsPDFRenderer(bounds: bounds)
		return pdfRenderer.pdfData { context in
			context.beginPage()
			layer.render(in: context.cgContext)
		}
	}
}
