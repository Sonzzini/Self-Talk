//
//  VoiceRecognitionView.swift
//  SpeechRecognition
//
//  Created by Your Name on Date.
//

import SwiftUI
import Speech
import AVFoundation


// MARK: Não funcionando
struct VoiceRecognitionView: View {
	 @State private var isRecording = false
	 @State private var recognizedText = ""
	 
	 var body: some View {
		  VStack {
				Text("Say 'hello' or 'goodbye'")
					 .font(.title)
				
				Button(action: {
					 self.startRecording()
				}) {
					 Text(isRecording ? "Stop Recording" : "Start Recording")
				}
				.padding()
				.background(Color.blue)
				.foregroundColor(.white)
				.clipShape(Capsule())
				
				Text(recognizedText)
					 .font(.title)
		  }
	 }
	 
	 func startRecording() {
		  if isRecording {
				// Stop recording
				isRecording = false
		  } else {
				// Start recording
				isRecording = true
				
				let node = AVAudioInputNode()
				let recordingFormat = node.outputFormat(forBus: 0)
				node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
					 self.requestSpeech(buffer: buffer)
				}
				
				AudioEngine.start()
				AudioEngine.inputNode.removeTap(onBus: 0)
				AudioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
					 self.requestSpeech(buffer: buffer)
				}
		  }
	 }
	 
	 func requestSpeech(buffer: AVAudioPCMBuffer) {
		  let request = SFSpeechAudioBufferRecognitionRequest()
		  request.shouldReportPartialResults = true
		  request.contextualStrings = ["hello", "goodbye"]
		  request.append(buffer)
		  
		  let recognitionTask = speechRecognizer.recognitionTask(with: request) { (result, error) in
				if let result = result {
					 self.recognizedText = result.bestTranscription.formattedString
					 if result.isFinal {
						  if self.recognizedText == "hello" {
								self.showAlert(title: "Hello!", message: "Greetings!")
						  } else if self.recognizedText == "goodbye" {
								self.showAlert(title: "Goodbye!", message: "Farewell!")
						  }
					 }
				}
		  }
	 }
	 
	 func showAlert(title: String, message: String) {
		  let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		  alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		  UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
	 }
}
