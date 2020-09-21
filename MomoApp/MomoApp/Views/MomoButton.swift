//
//  NextButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-16.
//

import SwiftUI

struct MomoButton: ButtonStyle {
    var w: CGFloat
    var h: CGFloat
    var size: CGFloat = 14.0
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .momoButtonText(size: size)
            .frame(width: w, height: h)
            .background(Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)))
            .cornerRadius(h / 2)
    }
}
