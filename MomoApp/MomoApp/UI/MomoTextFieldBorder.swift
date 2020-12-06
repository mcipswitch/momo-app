//
//  TextFieldBorder.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-02.
//

import SwiftUI

struct MomoTextFieldBorder: View {
    @Binding var textFieldIsFocused: Bool
    var height: CGFloat = 2

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: height / 2)
                .fill(Color.white)
            RoundedRectangle(cornerRadius: 2)
                .fill(textFieldIsFocused ? Color.momo : .clear)
                //.animation(.ease())
        }
        .frame(height: height)
    }
}
