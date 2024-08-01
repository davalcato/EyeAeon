//
//  SplashScreenView.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/6/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var navigateToLogin = false
    @State private var logoAnimation = false
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationView {
            VStack {
                if navigateToLogin {
                    NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                        EmptyView()
                    }
                    .hidden()
                } else {
                    VStack {
                        Image("EyeAeonLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding()
                            .opacity(logoAnimation ? 1 : 0) // Fade in animation

                        Text("EyeAeon")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.5)) {
                                    self.logoAnimation = true // Trigger logo animation
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        self.navigateToLogin = true // Navigate to LoginView after delay
                                    }
                                }
                            }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
