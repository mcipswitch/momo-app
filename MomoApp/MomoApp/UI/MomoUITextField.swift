//
//  MomoUITextField.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-23.
//

import SwiftUI

// MARK: - MomoUITextField

extension MomoUI {
    struct TextField: View {
        @Environment(\.textFieldStyle) var textFieldStyle
        @Binding var text: String
        @Binding var isFocused: Bool

        var body: some View {
            ZStack(alignment: .center) {
                placeholder
                    .opacity(self.text.isEmpty ? textFieldStyle.placeholderOpacity : 0)
                    .animation(nil, value: self.text)

                    // Dim text when text field is focused
                    .opacity(self.isFocused ? 0.4 : textFieldStyle.placeholderOpacity)
                    .animation(.easeInOut, value: self.isFocused)
                textField
                    .onReceive(self.text.publisher.collect()) { _ in
                        self.text = self.text.applyCharLimit(textFieldStyle.charLimit)
                    }
            }
        }
    }

}

// MARK: - Internal Views

extension MomoUI.TextField {
    private var placeholder: some View {
        Text("My day in a word".localized)
            .momoText(.mainMessageFont)
    }

    private var textField: some View {
        TextField("", text: $text, onEditingChanged: { editingChanged in
            self.isFocused = editingChanged ? true : false
        }, onCommit: {

            // TODO: - TBD
            print(text)

        })
        .msk_applyMomoTextFieldStyle()
    }
}

// MARK: - MomoUITextFieldBorder

extension MomoUI {
    struct TextFieldBorder: View {
        @Environment(\.textFieldStyle) var textFieldStyle
        @Binding var isFocused: Bool

        var body: some View {
            RoundedRectangle(cornerRadius: textFieldStyle.borderCornerRadius)
                .fill(isFocused ? Color.momo : .white)
                .animation(.ease, value: isFocused)
                .frame(height: textFieldStyle.borderHeight)
        }
    }
}

// MARK: - MomoTextFieldStyle

struct MomoTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .momoText(.mainMessageFont)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .accentColor(.momo)
            //.minimumScaleFactor(0.8)
    }
}

// MARK: - View+Extension

extension View {
    func msk_applyMomoTextFieldStyle() -> some View {
        return self.textFieldStyle(MomoTextFieldStyle())
    }
}
