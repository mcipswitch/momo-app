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
    @Binding var textFieldIsFocused: Bool
    let onTextFieldChange: (CGFloat) -> Void

    var body: some View {
        ZStack(alignment: .center) {
            PlaceholderText(text: NSLocalizedString("My day in a word", comment: ""))
                .opacity(text.isEmpty ? textFieldStyle.placeholderOpacity : 0)
                .animation(nil, value: text)

            TextField("", text: $text, onEditingChanged: { editingChanged in
                self.textFieldIsFocused = editingChanged ? true : false
            }, onCommit: {

                // TODO: Emotion Added view
                print(text)

            })
            .msk_applyMomoTextFieldStyle()
            .onReceive(text.publisher.collect()) { char in
                text = String(text.prefix(textFieldStyle.charLimit))
            }
        }
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

// MARK: - MomoTextFieldPlaceholder

struct PlaceholderText: View {
    let text: String
    var body: some View {
        Text(text)
            .msk_applyTextStyle(.mainMessageFont)
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
