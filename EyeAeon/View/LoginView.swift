//
//  LoginView.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/6/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginData = LoginViewModel()
    @State private var showErrorAlert = false
    @State private var navigateToMainPage = false
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
                    hint: "example@gmail.com",
                    value: $loginData.email,
                    isSecure: false,
                    showPassword: .constant(false)
                )
                .padding(.horizontal, 50)

                CustomTextField(
                    icon: "lock",
                    title: "Password",
                    hint: "Enter your password",
                    value: $loginData.password,
                    isSecure: true,
                    showPassword: $loginData.showPassword
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
                    )
                    .padding(.horizontal, 50)
                    .padding(.bottom, 20)
                }

                Button(action: {
                    if loginData.registerUser {
                        if loginData.registerUserValid() {
                            loginData.register { success in
                                if success {
                                    showSuccessMessage = true
                                    showFailureMessage = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            appState.isLoggedIn = true
                                        }
                                    }
                                } else {
                                    loginData.errorMessage = "Registration failed. Please try again."
                                    showFailureMessage = true
                                    showSuccessMessage = false
                                }
                            }
                        } else {
                            loginData.errorMessage = "Please make sure all fields are filled and passwords match."
                            showErrorAlert = true
                        }
                    } else {
                        if loginData.loginUserValid() {
                            if loginData.login() {
                                appState.isLoggedIn = true
                            } else {
                                loginData.errorMessage = "Incorrect email or password. Please try again."
                                showErrorAlert = true
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

                NavigationLink(
                    destination: MainPageView(),
                    isActive: $navigateToMainPage
                ) {
                    EmptyView()
                }
                .hidden()

                Spacer()

                Button(action: {
                    loginData.registerUser.toggle()
                }) {
                    Text(loginData.registerUser ? "Already have an account? Login" : "Don't have an account? Register")
                        .foregroundColor(.blue)
                        .padding(.top, 10)
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AppState(isLoggedIn: false))
    }
}
