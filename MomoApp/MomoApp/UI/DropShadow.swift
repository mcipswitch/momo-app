//
//  DropShadow.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-14.
//

import SwiftUI

// MARK: - ViewModifier

// TODO: - make this more reusable

struct DropShadow: ViewModifier {
    @Environment(\.dropShadowStyle) var dropShadowStyle

    func body(content: Content) -> some View {
        content
            .shadow(color: dropShadowStyle.color.opacity(dropShadowStyle.opacity),
                    radius: dropShadowStyle.radius,
                    x: dropShadowStyle.offset.x,
                    y: dropShadowStyle.offset.y)
    }
}

// MARK: - View+Extension

extension View {
    func msk_applyDropShadow() -> some View {
        return self.modifier(DropShadow())
    }
}