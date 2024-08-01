//
//  SceneDelegate.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/28/24.
//

import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    @StateObject private var sharedDataModel = SharedDataModel()
    @StateObject private var userModel = UserModel()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = MainPageView()
            .environmentObject(sharedDataModel)
            .environmentObject(userModel)

        if let windowScene = scene as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = UIHostingController(rootView: contentView)
            window?.makeKeyAndVisible()
        }
    }
}


#Preview {
    SceneDelegate() as! any View
}
