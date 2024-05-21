//
//  ARContainerView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 17/05/24.
//

import Foundation
import SwiftUI
import Speech
import AVFoundation

struct ARContainerView: View {
	@EnvironmentObject var vm: ViewModel
	
	@Environment(\.dismiss) private var dismiss
	
	var scene: SceneModel
	@State var isEvaluating: Bool = false
	@State var isPaused: Bool = true
	
	@State var scriptChunks: [String] = [""]
	@State var currentChunkIndex: Int = 0
	
	@State var shouldDismiss: Bool = false
	
	// MARK: - Voice recognition
	@State private var speechText = "Fale algo..."
	@State private var isRecording = false
	
	@State private var speechRecognizer: SFSpeechRecognizer?
	private let audioEngine = AVAudioEngine()
	
	
	private func requestAuthorization() {
		SFSpeechRecognizer.requestAuthorization { authStatus in
			DispatchQueue.main.async {
				if authStatus != .authorized {
					self.speechText = "Acesso ao reconhecimento de voz não permitido."
				}
			}
		}
	}
	
	private func startRecording() {
		let audioSession = AVAudioSession.sharedInstance()
		do {
			try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
			try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
		} catch {
			self.speechText = "Falha ao configurar a sessão de áudio."
			return
		}
		
		let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
		let inputNode = audioEngine.inputNode
		
		recognitionRequest.shouldReportPartialResults = true
		let recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
			var isFinal = false
			if let result = result {
				self.speechText = result.bestTranscription.formattedString
				isFinal = result.isFinal
			}
			
			if error != nil || isFinal {
				self.stopRecording()
			}
		}
		
		let recordingFormat = inputNode.outputFormat(forBus: 0)
		inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
			recognitionRequest.append(buffer)
		}
		
		audioEngine.prepare()
		do {
			try audioEngine.start()
		} catch {
			self.speechText = "Áudio engine não pode ser iniciado."
			return
		}
		
		self.isRecording = true
	}
	
	private func stopRecording() {
		audioEngine.stop()
		audioEngine.inputNode.removeTap(onBus: 0)
		isRecording = false
	}
	
	
	var body: some View {
		NavigationStack {
			ZStack {
				ARView()
					.edgesIgnoringSafeArea(.all)
				
				if isRecording {
					VStack {
						Spacer()
						
						currentScriptText
						
						Text(speechText)
						
						
						ZStack {
							HStack {
								previousChunkButton
								
								nextChunkButton
							}
							
							HStack {
								Spacer()
								NavigationLink {
									ResultsView(shouldDismiss: $shouldDismiss, scriptText: scene.script ?? "SCRIPT_TEXT", patientText: speechText, scene: scene)
								} label: {
									Text("Terminar")
								}
							}
						}
						
						
						
					}
					
					.padding(.vertical)
					.onChange(of: shouldDismiss) { oldValue, newValue in
						dismiss()
					}
				}
				
				recordingButton
					.position(x: isRecording ? UIScreen.main.bounds.width * 0.9 : UIScreen.main.bounds.width / 2,
								 y: isRecording ? 0 : UIScreen.main.bounds.height * 0.5)
				
			}
			.onAppear {
				scriptChunks = vm.splitStringIntoChunks(scene.script ?? "SCENE_SCRIPT", wordsPerChunk: 5)
				speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "pt-BR"))
				
			}
			.onDisappear {
				stopRecording()
			}
		}
	}
}

#Preview {
	ARContainerView(scene: SceneModel())
		.environmentObject(ViewModel())
}

extension ARContainerView {
	private var nextChunkButton: some View {
		Button {
			if currentChunkIndex != scriptChunks.count - 1 {
				currentChunkIndex += 1
			}
		} label: {
			Text("Próximo")
		}
	}
	
	private var previousChunkButton: some View {
		Button {
			if currentChunkIndex != 0 {
				currentChunkIndex -= 1
			}
		} label: {
			Text("Anterior")
		}
	}
	
	private var currentScriptText: some View {
		Text(scriptChunks[currentChunkIndex])
			.font(.title)
			.foregroundStyle(.white)
			.padding()
			.background(Color.black.opacity(0.7))
			.clipShape(RoundedRectangle(cornerRadius: 10))
	}
	
	private var recordingButton: some View {
		Button {
			withAnimation(.easeInOut(duration: 0.5)) {
				isRecording.toggle()
				
				if isRecording {
					startRecording()
					isPaused = false
				} else {
					stopRecording()
					isPaused = true
				}
			}
		} label: {
			Text(isRecording ? "Parar gravação" : "Começar cenário")
				.fontWeight(.semibold)
				.foregroundStyle(.white)
				.padding()
				.padding(.horizontal)
				.background(isRecording ? Color.red : Color.glaucous)
				.clipShape(RoundedRectangle(cornerRadius: 12))
		}
	}
}
