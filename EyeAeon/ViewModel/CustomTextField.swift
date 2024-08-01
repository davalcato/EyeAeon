//
//  CustomTextField.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/8/24.
//

import SwiftUI

struct CustomTextField: View {
    var icon: String
    var title: String
    var hint: String
    @Binding var value: String
    var isSecure: Bool
    @Binding var showPassword: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)

                if isSecure && !showPassword {
                    SecureField(hint, text: $value)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } else {
                    TextField(hint, text: $value)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }

                if isSecure {
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)

            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}


struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(icon: "envelope", title: "Email", hint: "rumenguin@gmail.com", value: .constant(""), isSecure: false, showPassword: .constant(false))
    }
}


#Preview {
    CustomTextField(icon: "envelope", title: "Email", hint: "rumenguin@gmail.com", value: .constant(""), isSecure: false, showPassword: .constant(false))
}
