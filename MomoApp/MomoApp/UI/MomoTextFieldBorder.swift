//
//  TextFieldBorder.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-02.
//

import SwiftUI

struct MomoTextFieldBorder: View {
    @Binding var textFieldIsFocused: Bool
    let height = Momo.TextField.Border.height
    private var cornerRadius: CGFloat { height / 2 }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(textFieldIsFocused ? Color.momo : .white)
            .animation(.ease(), value: textFieldIsFocused)
            .frame(height: height)
    }
}
