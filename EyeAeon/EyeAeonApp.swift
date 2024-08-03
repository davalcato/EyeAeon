//
//  EyeAeonApp.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/6/24.
//

// Import necessary modules
import SwiftUI
import Firebase
import GoogleSignIn

// AppDelegate class for Firebase setup
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handle Google Sign-In callback
        return GIDSignIn.sharedInstance.handle(url)
    }
}


// Main App structure
@main
struct EyeAeonApp: App {
    // Register AppDelegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Define state objects for shared data and user state
    @StateObject private var sharedDataModel = SharedDataModel()
    @StateObject private var userModel = UserModel()
    @StateObject private var appState = AppState(isLoggedIn: UserDefaults.standard.bool(forKey: "log_Status"))
    
    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                MainPageView()
                    .environmentObject(appState)
                    .environmentObject(sharedDataModel)
                    .environmentObject(userModel)
            } else {
                SplashScreenView()
                    .environmentObject(appState)
            }
        }
    }
}



