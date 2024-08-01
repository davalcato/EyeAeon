//
//  TextDetectionView.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/15/24.
//

import SwiftUI

struct TextDetectionView: View {
    @State private var inputText: String = ""
    @State private var detectedText: String = ""
    @State private var isAIText: Bool?
    @Environment(\.presentationMode) var presentationMode

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

            // Page Title
            Text("Text Detection Page")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            // Text input field
            VStack {
                TextEditor(text: $inputText)
                    .padding()
                    .frame(height: 200)
                    .border(Color.gray, width: 1)
                    .cornerRadius(8)
                    .padding()

                Button(action: analyzeText) {
                    Text("Analyze Text")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.bottom)
            }
            .padding(.vertical)

            // Text Detection Results Display
            VStack(alignment: .leading, spacing: 8) {
                Text("Detected Text:")
                    .font(.headline)
                    .fontWeight(.bold)

                Text(detectedText)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.vertical, 8)

                if let isAIText = isAIText {
                    HStack {
                        Text(isAIText ? "AI Generated" : "Human Written")
                            .foregroundColor(isAIText ? .green : .red)
                        Image(systemName: isAIText ? "checkmark.circle" : "xmark.circle")
                            .foregroundColor(isAIText ? .green : .red)
                    }
                    .font(.title)
                    .padding(.top)
                }
            }
            .padding()

            Spacer()
        }
        .navigationBarTitle("Text Detection", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .background(
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        )
    }

    private func analyzeText() {
        // Simulate text detection by copying the input text to detected text
        detectedText = inputText

        // Mock AI detection logic
        isAIText = isTextAI(inputText)
    }

    // Mock function to simulate AI text detection
    private func isTextAI(_ text: String) -> Bool {
        // Replace this with actual model or API call logic
        return text.lowercased().contains("ai")
    }
}

struct TextDetectionView_Previews: PreviewProvider {
    static var previews: some View {
        TextDetectionView()
    }
}




#Preview {
    TextDetectionView()
}
