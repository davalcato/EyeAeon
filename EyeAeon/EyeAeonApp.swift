//
//  EyeAeonApp.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/6/24.
//

import SwiftUI

@main
struct EyeAeonApp: App {
    @StateObject private var sharedDataModel = SharedDataModel()
    @StateObject private var userModel = UserModel()
    @StateObject private var appState = AppState(isLoggedIn: UserDefaults.standard.bool(forKey: "log_Status"))
        
        var body: some Scene {
            WindowGroup {
                if appState.isLoggedIn {
                    MainPageView()
                        .environmentObject(appState)
                        .environmentObject(SharedDataModel())
                        .environmentObject(UserModel())
                } else {
                    SplashScreenView()
                        .environmentObject(appState)
                }
            }
        }
    }


