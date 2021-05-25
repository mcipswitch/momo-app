//
//  MomoBackground.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-15.
//

import SwiftUI

// MARK: - MomoBackground

struct MomoBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RadialGradient(gradient: .momo(.standardBackground),
                               center: .center,
                               startRadius: 10,
                               endRadius: 500)
                    .edgesIgnoringSafeArea(.all)
            )
    }
}

// MARK: - View+Extension

extension View {
    func momoBackground() -> some View {
        return self.modifier(MomoBackgroundModifier())
    }
}
