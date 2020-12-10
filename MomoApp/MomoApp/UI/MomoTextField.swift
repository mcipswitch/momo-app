//
//  MomoTextField.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-23.
//

import SwiftUI

// MARK: - MomoTextField

struct MomoTextField: View {
    @Binding var text: String
    @Binding var textFieldIsFocused: Bool

    var body: some View {
        ZStack(alignment: .center) {
            Text("My day in a word")
                .momoText(.main)
                .opacity(self.text.isEmpty ? 0.6 : 0)
                .animation(.ease(), value: self.text)
            TextField("", text: $text, onEditingChanged: { editingChanged in
                self.textFieldIsFocused = editingChanged ? true : false
            }, onCommit: {
                // TODO
                print(text)
            })
            .momoTextFieldStyle()
            .onReceive(text.publisher.collect()) { char in
                self.text = String(text.prefix(20))
            }
        }
    }
}

// MARK: - MomoTextFieldStyle

struct MomoTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .momoText(.main)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .accentColor(Color.momo)
            .minimumScaleFactor(0.8)
    }
}

// MARK: - View+Extension

extension View {
    func momoTextFieldStyle() -> some View {
        return self.textFieldStyle(MomoTextFieldStyle())
    }
}
