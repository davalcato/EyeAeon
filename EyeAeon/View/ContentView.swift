//
//  ContentView.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/6/24.
//

import SwiftUI

struct ContentView: View {
    @State private var text: String = ""

    var body: some View {
        VStack {
            TextField("Enter text", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // Resign first responder
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }) {
                Text("Dismiss Keyboard")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}



#Preview {
    ContentView()
}

