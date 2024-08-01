//
//  AppState.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/30/24.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool
    
    init(isLoggedIn: Bool) {
        self.isLoggedIn = isLoggedIn
    }
}


#Preview {
    AppState(isLoggedIn: true)as! any View
}
