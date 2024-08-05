//
//  LoginViewModel.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/9/24.
//

import SwiftUI
import Combine
import KeychainSwift

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var reEnterPassword: String = ""
    @Published var showPassword: Bool = false
    @Published var showReEnterPassword: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var registerUser: Bool = false

    private let keychain = KeychainSwift()

    func registerUserValid() -> Bool {
        return !email.isEmpty && !password.isEmpty && password == reEnterPassword
    }

    func loginUserValid() -> Bool {
        return !email.isEmpty && !password.isEmpty
    }

    func register(completion: @escaping (Bool) -> Void) {
        // Storing credentials securely using KeychainSwift
        keychain.set(email, forKey: "email")
        keychain.set(password, forKey: "password")
        completion(true)
    }

    func login(completion: @escaping (Bool) -> Void) {
        // Retrieve stored credentials from Keychain
        guard let storedEmail = keychain.get("email"), let storedPassword = keychain.get("password") else {
            errorMessage = "No stored credentials found. Please register first."
            completion(false)
            return
        }

        // Check if the entered credentials match the stored credentials
        if email == storedEmail && password == storedPassword {
            isLoggedIn = true
            completion(true)
        } else {
            errorMessage = "Incorrect email or password. Please try again."
            completion(false)
        }
    }
}



#Preview {
    LoginViewModel() as! any View
}
