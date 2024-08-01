//
//  ImagePickerCoordinator.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/17/24.
//

import UIKit
import SwiftUI

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var image: UIImage?
    @Binding var isImagePickerPresented: Bool

    init(image: Binding<UIImage?>, isImagePickerPresented: Binding<Bool>) {
        _image = image
        _isImagePickerPresented = isImagePickerPresented
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = pickedImage
        }
        isImagePickerPresented = false
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isImagePickerPresented = false
    }
}

