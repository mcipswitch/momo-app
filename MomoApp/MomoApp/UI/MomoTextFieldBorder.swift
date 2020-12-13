//
//  TextFieldBorder.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-02.
//

import SwiftUI

struct MomoTextFieldBorder: View {
    typealias TextFieldBorder = Momo.TextField.Border

    @Binding var textFieldIsFocused: Bool
    private var cornerRadius: CGFloat { TextFieldBorder.height / 2 }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(textFieldIsFocused ? Color.momo : .white)
            .animation(.ease, value: textFieldIsFocused)
            .frame(height: TextFieldBorder.height)
    }
}
