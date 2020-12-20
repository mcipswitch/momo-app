//
//  MomoBackground.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-15.
//

import SwiftUI

// MARK: - MomoBackground

struct MomoBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RadialGradient(gradient: .momoBackgroundGradient,
                               center: .center,
                               startRadius: 10,
                               endRadius: 500)
                    .edgesIgnoringSafeArea(.all)
            )
    }
}

// MARK: - View+Extension

extension View {
    func msk_applyMomoBackground() -> some View {
        return self.modifier(MomoBackground())
    }
}
