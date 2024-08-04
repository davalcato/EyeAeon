//
//  FacebookLoginButtonView.swift
//  Pods
//
//  Created by Ethan Hunt on 8/3/24.
//

import SwiftUI
import FBSDKLoginKit

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

struct FacebookLoginButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FacebookLoginButtonView()
    }
}




#Preview {
    FacebookLoginButtonView()
}
