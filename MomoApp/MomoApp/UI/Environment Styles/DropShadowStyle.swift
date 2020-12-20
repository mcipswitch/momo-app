//
//  DropShadowStyle.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-20.
//

import SwiftUI

// MARK: - ButtonStyleKit

public struct DropShadowStyle {
    let color: Color
    let opacity: Double
    let radius: CGFloat
    let offset: CGPoint

    init(
        color: Color = .black,
        opacity: Double = 0.6,
        radius: CGFloat = 20.0,
        offset: CGPoint = CGPoint(x: 4, y: 4)
    ) {
        self.color = color
        self.opacity = opacity
        self.radius = radius
        self.offset = offset
    }
}

// MARK: - ButtonStyleKitEnvironmentKey

struct DropShadowStyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: DropShadowStyle = .init()
}

// MARK: - EnvironmentValues+Extensions

extension EnvironmentValues {
    /// An additional environment value that will hold the button style.
    var dropShadowStyle: DropShadowStyle {
        get { self[DropShadowStyleEnvironmentKey.self] }
        set { self[DropShadowStyleEnvironmentKey.self] = newValue }
    }
}

// MARK: - View+Extensions

extension View {
    /// An extension on View protocol that allows us to insert chart styles into a view hierarchy environment.
    func msk_applyButtonStyle(_ style: DropShadowStyle) -> some View {
        environment(\.dropShadowStyle, style)
    }
}

