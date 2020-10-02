//
//  NextButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-16.
//

import SwiftUI

struct MomoButtonStyle: ButtonStyle {
    var w: CGFloat
    var h: CGFloat
    var size: CGFloat = 14.0
    var isActive: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .momoButtonText(size: size)
            .frame(width: w, height: h)
            .background(Color.momo)
            .cornerRadius(h / 2)
            .opacity(isActive ? 1 : 0.2)
    }
}
