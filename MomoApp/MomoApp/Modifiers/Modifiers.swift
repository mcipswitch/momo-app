//
//  Modifiers.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-18.
//

import SwiftUI

struct MomoText: ViewModifier {
    var opacity: Double
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: 22, weight: .bold))
            .foregroundColor(Color.white.opacity(opacity))
            .multilineTextAlignment(.center)
            .lineSpacing(4)
    }
}

extension View {
    func momoText(opacity: Double = 1) -> some View {
        return self.modifier(MomoText(opacity: opacity))
    }
}
