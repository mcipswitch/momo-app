//
//  MomoTextField.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-23.
//

import SwiftUI

// MARK: - MomoTextField

struct MomoTextField: View {
    typealias MTextField = MSK.TextField
    typealias MTextFieldPlaceholder = MSK.TextField.Placeholder

    @Binding var text: String
    @Binding var textFieldIsFocused: Bool
    let onTextFieldChange: (CGFloat) -> Void

    private var charLimit: Int {
        return MTextField.charLimit
    }

    private var placeholderOpacity: Double {
        return MTextFieldPlaceholder.opacity
    }

    var body: some View {
        ZStack(alignment: .center) {
            PlaceholderText(text: NSLocalizedString("My day in a word", comment: ""))
                .opacity(text.isEmpty ? placeholderOpacity : 0)
                .animation(nil, value: text)

            TextField("", text: $text, onEditingChanged: { editingChanged in
                self.textFieldIsFocused = editingChanged ? true : false
            }, onCommit: {
                // TODO
                print(text)
            })
            .msk_applyMomoTextFieldStyle()
            .onReceive(text.publisher.collect()) { char in
                text = String(text.prefix(charLimit))
            }
        }
    }
}

// MARK: - MomoTextFieldBorder

struct MomoTextFieldBorder: View {
    typealias TextFieldBorder = MSK.TextField.Border

    @Binding var isFocused: Bool

    private var cornerRadius: CGFloat {
        TextFieldBorder.cornerRadius
    }

    private var height: CGFloat {
        TextFieldBorder.height
    }

    //private var cornerRadius: CGFloat { TextFieldBorder.height / 2 }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(isFocused ? Color.momo : .white)
            .animation(.ease, value: isFocused)
            .frame(height: height)
    }
}

// MARK: - MomoTextFieldPlaceholder

struct PlaceholderText: View {
    let text: String
    var body: some View {
        Text(text)
            .msk_applyStyle(.mainMessageFont)
            .multilineTextAlignment(.center)
            .lineLimit(1)
    }
}

// MARK: - MomoTextFieldStyle

struct MomoTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .msk_applyStyle(.mainMessageFont)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .accentColor(.momo)
            .minimumScaleFactor(0.8)
    }
}

// MARK: - TextField

extension MSK.TextField {
    static let charLimit: Int = 20

    struct Placeholder {
        static let lineLimit: Int = 1
        static let opacity: Double = 0.6
    }

    struct Border {
        static let height: CGFloat = 2
        static let cornerRadius: CGFloat = height / 2
    }
}

// MARK: - View+Extension

extension View {
    func msk_applyMomoTextFieldStyle() -> some View {
        return self.textFieldStyle(MomoTextFieldStyle())
    }
}







//// Track the width of the placeholder text and draw the border accordingly.
//.modifier(TextFieldSizeModifier())
//.onPreferenceChange(TextFieldSizePreferenceKey.self) {
//    print($0.width)
//    self.onTextFieldChange($0.width)
//}
