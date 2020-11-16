//
//  NextButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

struct NextButton: View {
    @Binding var isActive: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text("Next")
                Image(systemName: "arrow.right")
            }
        }.buttonStyle(MomoButtonStyle(w: 90, h: 34, isActive: isActive))
        .disabled(!isActive)
        .animation(.ease())
    }
}
