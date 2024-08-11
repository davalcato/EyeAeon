//
//  CameraView.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 8/10/24.
//

import SwiftUI
import AVFoundation
import Speech

struct CameraView: View {
    @Binding var isRecording: Bool
    @Binding var transcriptionText: String
    @Environment(\.presentationMode) var presentationMode
    
    @State private var audioEngine = AVAudioEngine()
    @State private var speechRecognizer = SFSpeechRecognizer()
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.top, 20)
            .padding(.leading, 20)

            Spacer()

            Text("Camera View")
                .font(.largeTitle)
                .padding()

            Text("Transcription: \(transcriptionText)")
                .padding()

            Spacer()

            Button(action: {
                if isRecording {
                    stopRecording()
                } else {
                    startRecording()
                }
            }) {
                Text(isRecording ? "Stop Recording" : "Start Recording")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .frame(width: 80, height: 80)
            }
            .padding(.bottom, 40)
        }
        .onDisappear {
            stopRecording()
        }
    }

    private func startRecording() {
        recognitionTask?.cancel()
        recognitionTask = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("AudioEngine couldn't start because of an error: \(error.localizedDescription)")
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                self.transcriptionText = result.bestTranscription.formattedString
            } else if let error = error {
                print("Speech recognition error: \(error.localizedDescription)")
            }
        }
        
        isRecording = true
    }

    private func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        isRecording = false
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(isRecording: .constant(false), transcriptionText: .constant(""))
    }
}






//#Preview {
//    CameraView(isRecording: <#Binding<Bool>#>, transcriptionText: <#Binding<String>#>)
//}
