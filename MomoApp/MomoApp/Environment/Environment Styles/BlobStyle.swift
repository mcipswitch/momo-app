//
//  BlobStyle.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-20.
//

import SwiftUI

// MARK: - BlobStyle

public struct BlobStyle {
    let frameSize: CGFloat
    let scale: CGFloat
    let isStatic: Bool

    // Blob Shape
    let bezier: UIBezierPath
    let pathBounds: CGRect

    // Shadow
    let shadowColor: Color
    let shadowRadius: CGFloat
    let shadowOffset: CGPoint

    // Inner Shadow: Top Left
    let innerTopLeftShadowDarkShadow: Color
    let innerTopLeftShadowLightShadow: Color
    let innerTopLeftShadowSpread: CGFloat
    let innerTopLeftShadowRadius: CGFloat

    // Inner Shadow: Bottom Right
    let innerBottomRightShadowDarkShadow: Color
    let innerBottomRightShadowLightShadow: Color
    let innerBottomRightShadowSpread: CGFloat
    let innerBottomRightShadowRadius: CGFloat

    var scaledFrame: CGFloat { frameSize * scale }
    var pathBoundsRadio: CGFloat { pathBounds.width / pathBounds.height }

    init(
        frameSize: CGFloat = 250,
        scale: CGFloat = 1,
        isStatic: Bool = false,

        bezier: UIBezierPath = .blob3,
        pathBounds: CGRect = UIBezierPath.calculateBounds(paths: [.blob3]),

        shadowColor: Color = Color.black.opacity(0.6),
        shadowRadius: CGFloat = 50,
        shadowOffset: CGPoint = CGPoint(x: 10, y: 10),

        innerTopLeftShadowDarkShadow: Color = Color.white.opacity(0.8),
        innerTopLeftShadowLightShadow: Color = Color.clear.opacity(1.0),
        innerTopLeftShadowSpread: CGFloat = 1.0,
        innerTopLeftShadowRadius: CGFloat = 30,

        innerBottomRightShadowDarkShadow: Color = Color.clear.opacity(1.0),
        innerBottomRightShadowLightShadow: Color = Color.momoShadow.opacity(0.6),
        innerBottomRightShadowSpread: CGFloat = 0.8,
        innerBottomRightShadowRadius: CGFloat = 30
    ) {
        self.frameSize = frameSize
        self.scale = scale
        self.isStatic = isStatic

        self.bezier = bezier
        self.pathBounds = pathBounds

        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset

        self.innerTopLeftShadowDarkShadow = innerTopLeftShadowDarkShadow
        self.innerTopLeftShadowLightShadow = innerTopLeftShadowLightShadow
        self.innerTopLeftShadowSpread = innerTopLeftShadowSpread
        self.innerTopLeftShadowRadius = innerTopLeftShadowRadius

        self.innerBottomRightShadowDarkShadow = innerBottomRightShadowDarkShadow
        self.innerBottomRightShadowLightShadow = innerBottomRightShadowLightShadow
        self.innerBottomRightShadowSpread = innerBottomRightShadowSpread
        self.innerBottomRightShadowRadius = innerBottomRightShadowRadius
    }
}

// MARK: - BlobStyleEnvironmentKey

struct BlobStyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: BlobStyle = .init()
}

// MARK: - EnvironmentValues+Extensions

extension EnvironmentValues {
    /// An additional environment value that will hold the button style.
    var blobStyle: BlobStyle {
        get { self[BlobStyleEnvironmentKey.self] }
        set { self[BlobStyleEnvironmentKey.self] = newValue }
    }
}

// MARK: - View+Extensions

extension View {
    /// An extension on View protocol that allows us to insert chart styles into a view hierarchy environment.
    func momoBlobStyle(_ style: BlobStyle) -> some View {
        environment(\.blobStyle, style)
    }
}
