//
//  MomoTextField.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-23.
//

import SwiftUI

// MARK: - MomoTextField

struct MomoTextField: View {
    typealias MomoTextField = Momo.TextField

    @Binding var text: String
    @Binding var textFieldIsFocused: Bool
    let charLimit = MomoTextField.charLimit
    let onTextFieldChange: (CGFloat) -> Void

    var body: some View {
        ZStack(alignment: .center) {

            // Placeholder
            Text(NSLocalizedString("Ma journée en un mot", comment: ""))
            //Text(NSLocalizedString("My day in a word", comment: ""))
                .momoText(.appMain)

                .lineLimit(1)

                .opacity(self.text.isEmpty ? placeHolderOpacity : 0)
                .animation(nil, value: self.text)


                // Track the width of the placeholder text and draw the border accordingly.
                .modifier(TextFieldSizeModifier())
                .onPreferenceChange(TextFieldSizePreferenceKey.self) {
                    print($0.width)
                    self.onTextFieldChange($0.width)
                }





            // TextField
            TextField("", text: $text, onEditingChanged: { editingChanged in
                self.textFieldIsFocused = editingChanged ? true : false
            }, onCommit: {
                // TODO
                print(text)
            })
            .momoTextFieldStyle()
            .onReceive(text.publisher.collect()) { char in
                self.text = String(self.text.prefix(self.charLimit))
            }
        }
    }
}

// MARK: - MomoTextFieldStyle

struct MomoTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .momoText(.appMain)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .accentColor(Color.momo)
            .minimumScaleFactor(minimumScaleFactor)
    }
}

// MARK: - View+Extension

extension View {
    func momoTextFieldStyle() -> some View {
        return self.textFieldStyle(MomoTextFieldStyle())
    }
}
