//
//  MomoTextField.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-23.
//

import SwiftUI

// MARK: - MomoTextField

struct MomoTextField: View {
    @Environment(\.textFieldStyle) var textFieldStyle
    @Binding var text: String
    @Binding var isFocused: Bool

    init(_ text: Binding<String>, isFocused: Binding<Bool>) {
        self._text = text
        self._isFocused = isFocused
    }

    var body: some View {
        ZStack(alignment: .center) {
            placeholder
                .opacity(self.text.isEmpty ? textFieldStyle.placeholderOpacity : 0)
                .animation(nil, value: self.text)
                // Dim text when text field is focused
                .opacity(self.isFocused ? 0.1 : textFieldStyle.placeholderOpacity)
                .animation(.easeOut(duration: 0.2), value: self.isFocused)
            textField
                .onReceive(self.text.publisher.collect()) { _ in
                    self.text = self.text.applyCharLimit(textFieldStyle.charLimit)
                }
        }
    }
}

// MARK: - Internal Views

extension MomoTextField {
    private var placeholder: some View {
        Text("My day in a word".localized)
            .msk_applyTextStyle(.mainMessageFont)
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

// MARK: - MomoTextFieldBorder

struct MomoTextFieldBorder: View {
    @Environment(\.textFieldStyle) var textFieldStyle
    @Binding var isFocused: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: textFieldStyle.borderCornerRadius)
            .fill(isFocused ? Color.momo : .white)
            .animation(.ease, value: isFocused)
            .frame(height: textFieldStyle.borderHeight)
    }
}

// MARK: - MomoTextFieldStyle

struct MomoTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .msk_applyTextStyle(.mainMessageFont)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .accentColor(.momo)
            .minimumScaleFactor(0.8)
    }
}

// MARK: - View+Extension

extension View {
    func msk_applyMomoTextFieldStyle() -> some View {
        return self.textFieldStyle(MomoTextFieldStyle())
    }
}
