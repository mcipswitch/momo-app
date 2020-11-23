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
                    .momoTextBold(opacity: text.isEmpty ? 0.6 : 0)

                TextField("", text: $text, onEditingChanged: { editingChanged in
                    textFieldIsFocused = editingChanged ? true : false
                }, onCommit: {
                    // TODO
                    print(text)
                })
                .textFieldStyle(EmotionTextFieldStyle())
                .onReceive(text.publisher.collect()) { _ in
                    self.text = String(text.prefix(20))
                }
            }
            .slideIn(if: $homeViewActive)

            MomoTextFieldBorder(showHome: $homeViewActive, textFieldIsFocused: $textFieldIsFocused)
        }
    }
}
