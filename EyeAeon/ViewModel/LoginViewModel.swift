//
//  LoginViewModel.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/9/24.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var reEnterPassword: String = ""
    @Published var showPassword: Bool = false
    @Published var showReEnterPassword: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var registerUser: Bool = false

    func registerUserValid() -> Bool {
        return !email.isEmpty && !password.isEmpty && password == reEnterPassword
    }

    func loginUserValid() -> Bool {
        return !email.isEmpty && !password.isEmpty
    }

    func register(completion: @escaping (Bool) -> Void) {
        // Save the credentials for simplicity; normally, you would use secure storage
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(password, forKey: "password")
        completion(true)
    }

    func login() -> Bool {
        // Retrieve the stored credentials
        let storedEmail = UserDefaults.standard.string(forKey: "email")
        let storedPassword = UserDefaults.standard.string(forKey: "password")

        // Check if the entered credentials match the stored credentials
        if email == storedEmail && password == storedPassword {
            isLoggedIn = true
            return true
        } else {
            errorMessage = "Incorrect email or password. Please try again."
            return false
        }
    }
}



#Preview {
    LoginViewModel() as! any View
}
