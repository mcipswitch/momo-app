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
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .momoButtonText(size: size)
            .frame(width: w, height: h)
            .background(Color.momo)
            .cornerRadius(h / 2)
    }
}
