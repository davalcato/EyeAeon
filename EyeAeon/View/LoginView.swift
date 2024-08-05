//
//  LoginView.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/6/24.
//

import SwiftUI
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import FBSDKLoginKit
import KeychainSwift

// Extension to get the top-most view controller
extension UIApplication {
    var topMostViewController: UIViewController? {
        guard let rootViewController = windows.first?.rootViewController else {
            return nil
        }
        return getTopViewController(from: rootViewController)
    }

    private func getTopViewController(from rootViewController: UIViewController) -> UIViewController? {
        if let presentedViewController = rootViewController.presentedViewController {
            return getTopViewController(from: presentedViewController)
        }
        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.topViewController
        }
        if let tabBarController = rootViewController as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return getTopViewController(from: selected)
            }
        }
        return rootViewController
    }
}

// SwiftUI wrapper for Facebook Login Button
struct FacebookLoginButtonView: UIViewRepresentable {
    func makeUIView(context: Context) -> FBLoginButton {
        let loginButton = FBLoginButton()
        loginButton.delegate = context.coordinator
        return loginButton
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: Context) {
        // Update the view if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, LoginButtonDelegate {
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            // Successfully logged in
            if let token = AccessToken.current {
                print("Access Token: \(token.tokenString)")
            }
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            print("User logged out")
        }
    }
}

struct LoginView: View {
    @StateObject private var loginData = LoginViewModel()
    @State private var showErrorAlert = false
    @State private var showSuccessMessage = false
    @State private var showFailureMessage = false
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Image(systemName: "person.circle")
                    .font(.system(size: 100))
                    .foregroundColor(.blue)

                Text(loginData.registerUser ? "Register" : "Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                CustomTextField(
                    icon: "envelope",
                    title: "Email",
                    hint: "example@example.com",
                    value: $loginData.email,
                    isSecure: false,
                    showPassword: .constant(false)
//                    showError: false
                )
                .padding(.horizontal, 50)

                CustomTextField(
                    icon: "lock",
                    title: "Password",
                    hint: "Enter your password",
                    value: $loginData.password,
                    isSecure: true,
                    showPassword: $loginData.showPassword
//                    showError: false
                )
                .padding(.horizontal, 50)
                .padding(.bottom, 20)

                if loginData.registerUser {
                    CustomTextField(
                        icon: "lock",
                        title: "Re-enter Password",
                        hint: "Re-enter your password",
                        value: $loginData.reEnterPassword,
                        isSecure: true,
                        showPassword: $loginData.showReEnterPassword
//                        showError: false
                    )
                    .padding(.horizontal, 50)
                    .padding(.bottom, 20)
                }

                Button(action: {
                    if loginData.registerUser {
                        if loginData.registerUserValid() {
                            loginData.register { success in
                                DispatchQueue.main.async {
                                    if success {
                                        print("Registration successful") // Debug print
                                        showSuccessMessage = true
                                        showFailureMessage = false
                                        appState.isLoggedIn = true
                                    } else {
                                        print("Registration failed") // Debug print
                                        showFailureMessage = true
                                        showSuccessMessage = false
                                    }
                                }
                            }
                        } else {
                            loginData.errorMessage = "Please make sure all fields are filled and passwords match."
                            showErrorAlert = true
                        }
                    } else {
                        if loginData.loginUserValid() {
                            loginData.login { success in
                                DispatchQueue.main.async {
                                    if success {
                                        appState.isLoggedIn = true
                                    } else {
                                        loginData.errorMessage = "Incorrect email or password."
                                        showErrorAlert = true
                                    }
                                }
                            }
                        } else {
                            loginData.errorMessage = "Email and password cannot be empty."
                            showErrorAlert = true
                        }
                    }
                }) {
                    Text(loginData.registerUser ? "Register" : "Login")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 50)
                }
                .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text("Error"), message: Text(loginData.errorMessage), dismissButton: .default(Text("OK")))
                }

                if showSuccessMessage {
                    Text("Registration successful!")
                        .foregroundColor(.green)
                        .padding(.top, 10)
                }

                if showFailureMessage {
                    Text("Registration failed. Please try again.")
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }

                // Google Sign-In Button
                Button(action: handleGoogleSignIn) {
                    HStack {
                        Image(systemName: "globe")
                        Text("Sign in with Google")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50) // Set fixed size for both buttons
                    .background(Color.red)
                    .cornerRadius(8)
                }
                .padding(.top)

                // Facebook Login Button
                FacebookLoginButtonView()
                    .frame(width: 300, height: 50) // Match the size of the Google button
                    .padding(.top, 10)
                    .cornerRadius(8)

                // Other UI components
                Spacer()

                Button(action: {
                    loginData.registerUser.toggle()
                }) {
                    Text(loginData.registerUser ? "Already have an account? Login" : "Don't have an account? Register")
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                        .cornerRadius(8)
                }
            }
            .navigationBarHidden(true)
            .background(
                GeometryReader { _ in
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                }
            )
        }
    }

    private func handleGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)

        guard let topViewController = UIApplication.shared.topMostViewController else {
            print("Unable to get top-most view controller.")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: topViewController) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard result != nil else { return }
            appState.isLoggedIn = true
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AppState(isLoggedIn: true))
    }
}
