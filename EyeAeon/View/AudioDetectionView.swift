//
//  AudioDetectionView.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/17/24.
//

import SwiftUI
import AVKit
import UniformTypeIdentifiers

struct AudioDetectionView: View {
    @State private var isAudioPickerPresented = false
    @State private var audioURL: URL?
    @State private var isAIAudio: Bool? = nil
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataModel: SharedDataModel

    var body: some View {
        VStack {
            // Top bar with back button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                Spacer()
            }
            .padding()

            Text("Audio Detection Page")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            // Example: Audio Input for Detection
            VStack {
                if let audioURL = audioURL {
                    AudioPlayer(url: audioURL)
                        .frame(height: 50)
                    
                    if let isAIAudio = isAIAudio {
                        Text(isAIAudio ? "AI Generated" : "Not AI Generated")
                            .foregroundColor(isAIAudio ? .green : .red)
                            .padding()
                        Image(systemName: isAIAudio ? "checkmark.circle" : "xmark.circle")
                            .foregroundColor(isAIAudio ? .green : .red)
                    }
                } else {
                    Image(systemName: "speaker.wave.2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding()
                }

                Button(action: {
                    isAudioPickerPresented = true
                }) {
                    Text("Tap to Upload Audio")
                        .foregroundColor(.blue)
                        .padding(.bottom)
                }
                .sheet(isPresented: $isAudioPickerPresented) {
                    AudioPickerView(audioURL: $audioURL, isPresented: $isAudioPickerPresented, isAIAudio: $isAIAudio, dataModel: dataModel)
                }
            }
            .padding(.vertical)

            // AI Detection Result
            Text("AI Detection Result:")
                .font(.headline)
                .fontWeight(.bold)

            if let isAIDetected = isAIAudio {
                HStack {
                    Text(isAIDetected ? "AI Generated" : "Not AI Generated")
                        .foregroundColor(isAIDetected ? .green : .red)
                    Image(systemName: isAIDetected ? "checkmark.circle" : "xmark.circle")
                        .foregroundColor(isAIDetected ? .green : .red)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            } else {
                Text("No audio analyzed yet.")
                    .foregroundColor(.gray)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }

            Spacer()
        }
        .navigationBarTitle("Audio Detection", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct AudioPickerView: UIViewControllerRepresentable {
    @Binding var audioURL: URL?
    @Binding var isPresented: Bool
    @Binding var isAIAudio: Bool?
    @ObservedObject var dataModel: SharedDataModel

    func makeUIViewController(context: Context) -> UIViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.audio])
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(audioURL: $audioURL, isPresented: $isPresented, isAIAudio: $isAIAudio, dataModel: dataModel)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        @Binding var audioURL: URL?
        @Binding var isPresented: Bool
        @Binding var isAIAudio: Bool?
        @ObservedObject var dataModel: SharedDataModel

        init(audioURL: Binding<URL?>, isPresented: Binding<Bool>, isAIAudio: Binding<Bool?>, dataModel: SharedDataModel) {
            _audioURL = audioURL
            _isPresented = isPresented
            _isAIAudio = isAIAudio
            self.dataModel = dataModel
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let pickedAudioURL = urls.first {
                audioURL = pickedAudioURL
                isAIAudio = classifyAudio(pickedAudioURL)
                dataModel.incrementAudioCount() // Increment the audio count when an audio file is selected
            }
            isPresented = false
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            isPresented = false
        }

        private func classifyAudio(_ url: URL) -> Bool {
            // Placeholder for AI classification logic
            // Replace this with your actual AI model inference code
            return Bool.random() // Randomly returning true or false for demonstration purposes
        }
    }
}

struct AudioDetectionView_Previews: PreviewProvider {
    static var previews: some View {
        AudioDetectionView().environmentObject(SharedDataModel())
    }
}





#Preview {
    AudioDetectionView()
}
