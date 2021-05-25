//
//  DropShadow.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-14.
//

import SwiftUI

// MARK: - ViewModifier

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
    func dropShadow() -> some View {
        return self.modifier(DropShadow())
    }
}
