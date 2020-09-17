//
//  NextButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-16.
//

import SwiftUI

struct MomoButton: ButtonStyle {
    var width: CGFloat
    var height: CGFloat
    var fontSize: CGFloat = 14.0
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width, height: height)
            .font(Font.system(size: fontSize, weight: .bold))
            .background(
                RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                    .fill(Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)))
            )
    }
}
