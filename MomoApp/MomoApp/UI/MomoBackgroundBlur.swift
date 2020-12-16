//
//  Blur.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-16.
//

import SwiftUI

// MARK: - MomoBackgroundBlur

struct MomoBackgroundBlur: ViewModifier {
    let blurStyle: UIBlurEffect.Style
    let value: Bool

    func body(content: Content) -> some View {
        content
            .overlay(
                VisualEffectBlur(blurStyle: blurStyle)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(value ? 1 : 0)
            )
    }
}

// MARK: - View+Extension

extension View {
    /// Applies a blur to the content of this view.
    /// - Parameters:
    ///   - blurStyle: Blur styles available for blur effect objects.
    ///   - value: Animates blur if this value is `true`.
    /// - Returns: A modified `View` instance.
    func msk_applyBackgroundBlurStyle(_ blurStyle: UIBlurEffect.Style, value: Bool) -> some View {
        return self.modifier(MomoBackgroundBlur(blurStyle: blurStyle, value: value))
    }
}
