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
    let charLimit = Momo.TextField.charLimit

    var body: some View {
        ZStack(alignment: .center) {
            Text("My day in a word")
                .momoText(.appMain)
                .opacity(self.text.isEmpty ? placeHolderOpacity : 0)
                .animation(nil, value: self.text)
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
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .accentColor(Color.momo)
            .minimumScaleFactor(Momo.TextField.minimumScaleFactor)
    }
}

// MARK: - View+Extension

extension View {
    func momoTextFieldStyle() -> some View {
        return self.textFieldStyle(MomoTextFieldStyle())
    }
}
