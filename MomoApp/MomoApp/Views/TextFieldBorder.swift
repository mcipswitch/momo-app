//
//  TextFieldBorder.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-21.
//

import SwiftUI

struct TextFieldBorder: View {
    @Binding var showHome: Bool
    @Binding var textFieldIsFocused: Bool
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(textFieldIsFocused ? Color.momo : .white)
            .frame(height: 2)
    }
    
}
