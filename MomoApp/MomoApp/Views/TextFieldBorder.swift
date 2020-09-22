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
            .fill(Color(textFieldIsFocused ? #colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .frame(height: 2)
            .offset(y: 32)
            .opacity(showHome ? 0 : 1)
            .frame(maxWidth: showHome ? 0 : .infinity)
            .animation(Animation
                        .interpolatingSpring(stiffness: 180, damping: 16)
                        .delay(showHome ? 0 : 0.6)
            )
    }
}
