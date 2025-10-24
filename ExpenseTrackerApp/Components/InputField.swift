//
//  InputField.swift
//  ExpenseTrackerApp
//
//  Created by Julian Giraldo on 24/10/25.
//

import SwiftUI

struct InputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let isSecure: Bool
    
    init(title: String, placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default, isSecure: Bool = false) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.isSecure = isSecure
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(keyboardType)
            .autocapitalization(.none)
            .disableAutocorrection(true)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        InputField(title: "Title", placeholder: "Enter transaction title", text: .constant(""))
        InputField(title: "Amount", placeholder: "0.00", text: .constant(""), keyboardType: .decimalPad)
    }
    .padding()
}
