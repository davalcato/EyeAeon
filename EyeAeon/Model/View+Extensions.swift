//
//  View+Extensions.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/15/24.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func onTapGestureToDismissKeyboard() -> some View {
        return self.onTapGesture {
            self.hideKeyboard()
        }
    }
}


