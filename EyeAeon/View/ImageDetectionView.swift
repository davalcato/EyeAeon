

import SwiftUI
import UIKit

struct ImageDetectionView: View {
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var isAIImage: Bool?
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

            Text("Image Detection Page")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            // Example: Image Input for Image Detection
            VStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding()
                    
                    if let isAI = isAIImage {
                        HStack {
                            Text(isAI ? "AI Generated" : "Not AI Generated")
                                .foregroundColor(isAI ? .green : .red)
                            Image(systemName: isAI ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(isAI ? .green : .red)
                        }
                    }
                } else {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding()
                }

                Button(action: {
                    isImagePickerPresented = true
                }) {
                    Text("Tap to Upload Image")
                        .foregroundColor(.blue)
                        .padding(.bottom)
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePickerView(image: $selectedImage, isImagePickerPresented: $isImagePickerPresented, isAIImage: $isAIImage)
                        .environmentObject(dataModel) // Pass the data model
                }
            }
            .padding(.vertical)

            // Example: Image Detection Results Display
            VStack(alignment: .leading, spacing: 8) {
                Text("Detected Text:")
                    .font(.headline)
                    .fontWeight(.bold)

                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.vertical, 8)

                // Additional image detection results can be displayed here
            }
            .padding()

            Spacer()
        }
        .navigationBarTitle("Image Detection", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isImagePickerPresented: Bool
    @Binding var isAIImage: Bool?
    @EnvironmentObject var dataModel: SharedDataModel // Add environment object

    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image, isImagePickerPresented: $isImagePickerPresented, isAIImage: $isAIImage, dataModel: dataModel)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary // Open the photo library
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Update any configuration of the UIViewController here
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: UIImage?
        @Binding var isImagePickerPresented: Bool
        @Binding var isAIImage: Bool?
        var dataModel: SharedDataModel

        init(image: Binding<UIImage?>, isImagePickerPresented: Binding<Bool>, isAIImage: Binding<Bool?>, dataModel: SharedDataModel) {
            _image = image
            _isImagePickerPresented = isImagePickerPresented
            _isAIImage = isAIImage
            self.dataModel = dataModel
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                image = pickedImage
                isAIImage = classifyImage(pickedImage)
                dataModel.incrementImageCount() // Increment the image count when an image is selected
            }
            isImagePickerPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isImagePickerPresented = false
        }
        
        private func classifyImage(_ image: UIImage) -> Bool {
            // Placeholder for AI classification logic
            // Replace this with your actual AI model inference code
            return Bool.random() // Randomly returning true or false for demonstration purposes
        }
    }
}





#Preview {
    ImageDetectionView()
}
