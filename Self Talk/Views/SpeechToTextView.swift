//
//  SpeechRecognitionView.swift
//  Self Talk
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 29/04/24.
//

import SwiftUI
import Speech
import AVFoundation

struct SpeechToTextView: View {
	 @State private var speechText = "Fale algo..."
	 @State private var isRecording = false
	 
	 private var speechRecognizer: SFSpeechRecognizer?
	 private let audioEngine = AVAudioEngine()
	 
	 init() {
		  speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "pt-BR"))
	 }
	 
	 var body: some View {
		  VStack(spacing: 20) {
				Text(speechText)
					 .padding()
					 .foregroundColor(isRecording ? .red : .black)
				
				Button(action: {
					 self.isRecording ? self.stopRecording() : self.startRecording()
				}) {
					 Text(isRecording ? "Parar" : "Começar a ouvir")
						  .foregroundColor(.white)
						  .padding()
						  .background(isRecording ? Color.red : Color.blue)
						  .cornerRadius(10)
				}
		  }
		  .onAppear {
				self.requestAuthorization()
		  }
	 }
	 
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
}

struct SpeechToTextView_Previews: PreviewProvider {
	 static var previews: some View {
		  SpeechToTextView()
	 }
}
