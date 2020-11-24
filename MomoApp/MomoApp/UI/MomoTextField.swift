//
//  MomoTextField.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-23.
//

import SwiftUI

struct MomoTextField: View {
    @Binding var homeViewActive: Bool
    @Binding var text: String
    @Binding var textFieldIsFocused: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .center) {

                // Placeholder
                Text("My day in a word")
                    .momoText(.main)
                    .opacity(text.isEmpty ? 0.6 : 0)
                TextField("", text: $text, onEditingChanged: { editingChanged in
                    textFieldIsFocused = editingChanged ? true : false
                }, onCommit: {
                    // TODO
                    print(text)
                })
                .momoTextFieldStyle()
                .onReceive(text.publisher.collect()) { _ in
                    self.text = String(text.prefix(20))
                }
            }
            .slideIn(if: $homeViewActive)

            MomoTextFieldBorder(showHome: $homeViewActive, textFieldIsFocused: $textFieldIsFocused)
        }
    }
}

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

extension View {
    func momoTextFieldStyle() -> some View {
        return self.textFieldStyle(MomoTextFieldStyle())
    }
}
