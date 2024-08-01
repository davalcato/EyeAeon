//
//  SwiftUIView.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/27/24.
//

import SwiftUI

class UserModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var profileImage: UIImage?

    func updateProfileImage(_ image: UIImage) {
        self.profileImage = image
    }

    func saveUserInfo() {
        UserDefaults.standard.set(firstName, forKey: "firstName")
        UserDefaults.standard.set(lastName, forKey: "lastName")
        UserDefaults.standard.set(email, forKey: "email")
    }

    func loadUserInfo() {
        self.firstName = UserDefaults.standard.string(forKey: "firstName") ?? ""
        self.lastName = UserDefaults.standard.string(forKey: "lastName") ?? ""
        self.email = UserDefaults.standard.string(forKey: "email") ?? ""
    }
}




//#Preview {
//    SwiftUIView()
//}
