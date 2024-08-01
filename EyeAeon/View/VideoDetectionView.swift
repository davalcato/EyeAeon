//
//  VideoDetectionView.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/17/24.
//

import SwiftUI
import AVKit

struct VideoDetectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isVideoPickerPresented = false
    @State private var videoURL: URL?
    @State private var isAIDetected: Bool? = nil
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

            Text("Video Detection Page")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            // Example: Video Input for Detection
            VStack {
                if let videoURL = videoURL {
                    VideoPlayer(url: videoURL)
                        .frame(height: 200)
                } else {
                    Image(systemName: "video")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding()
                }

                Button(action: {
                    isVideoPickerPresented = true
                }) {
                    Text("Tap to Upload Video")
                        .foregroundColor(.blue)
                        .padding(.bottom)
                }
                .sheet(isPresented: $isVideoPickerPresented) {
                    NavigationView {
                        VideoPickerView(videoURL: $videoURL, isPresented: $isVideoPickerPresented)
                            .navigationBarTitle("Video Picker", displayMode: .inline)
                            .navigationBarItems(trailing: Button("Cancel") {
                                isVideoPickerPresented = false
                            })
                    }
                }
            }
            .padding(.vertical)

            // Example: AI Detection Results Display
            VStack(alignment: .leading, spacing: 8) {
                Text("AI Detection Result:")
                    .font(.headline)
                    .fontWeight(.bold)

                if let isAIDetected = isAIDetected {
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
                    Text("No video analyzed yet.")
                        .foregroundColor(.gray)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .padding()

            Spacer()
        }
        .navigationBarTitle("Video Detection", displayMode: .inline)
        .onChange(of: videoURL, perform: { _ in
            analyzeVideo()
        })
    }

    private func analyzeVideo() {
        // Placeholder for the AI detection algorithm
        // Replace with actual AI detection logic
        if let _ = videoURL {
            // Simulate AI detection result
            isAIDetected = Bool.random()
            dataModel.incrementVideoCount() // Increment video count here
        } else {
            isAIDetected = nil
        }
    }
}

struct VideoPlayer: View {
    let url: URL

    var body: some View {
        Text("Video player placeholder for URL: \(url)")
            .frame(height: 200)
            .background(Color.gray.opacity(0.5))
            .cornerRadius(8)
    }
}

struct VideoPickerView: UIViewControllerRepresentable {
    @Binding var videoURL: URL?
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.mediaTypes = ["public.movie"]
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(videoURL: $videoURL, isPresented: $isPresented)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var videoURL: URL?
        @Binding var isPresented: Bool

        init(videoURL: Binding<URL?>, isPresented: Binding<Bool>) {
            _videoURL = videoURL
            _isPresented = isPresented
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedVideoURL = info[.mediaURL] as? URL {
                videoURL = pickedVideoURL
            }
            isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isPresented = false
        }
    }
}

struct VideoDetectionView_Previews: PreviewProvider {
    static var previews: some View {
        VideoDetectionView().environmentObject(SharedDataModel())
    }
}









#Preview {
    VideoDetectionView()
}
