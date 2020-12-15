//
//  DropShadow.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-14.
//

import SwiftUI

// MARK: - ViewModifier

struct DropShadow: ViewModifier {
    typealias shadow = MSK.DropShadow

    func body(content: Content) -> some View {
        content
            .shadow(color: shadow.color.opacity(shadow.opacity),
                    radius: shadow.radius,
                    x: shadow.offset.x,
                    y: shadow.offset.y)

            // Deprecated
            //.shadow(color: Color.black.opacity(0.6), radius: 20, x: 4, y: 4)
    }
}

// MARK: - DropShadow

extension MSK.DropShadow {
    static let color: Color = .black
    static let opacity: Double = 0.6
    static let radius: CGFloat = 20.0
    static let offset: CGPoint = CGPoint(x: 4, y: 4)
}

// MARK: - View+Extension

extension View {
    func msk_applyDropShadow() -> some View {
        return self.modifier(DropShadow())
    }
}
