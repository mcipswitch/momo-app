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
        RoundedRectangle(cornerRadius: self.height / 2)
            .fill(self.textFieldIsFocused ? Color.momo : .white)
            .animation(.ease(), value: self.textFieldIsFocused)
            .frame(height: self.height)
    }
}

//            RoundedRectangle(cornerRadius: height / 2)
//                .fill(Color.white)
