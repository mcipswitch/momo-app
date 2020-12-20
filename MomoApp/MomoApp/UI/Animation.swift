//
//  Animation.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-15.
//

import SwiftUI

// MARK: - Animations

struct TextFieldBorderAnimation: ViewModifier {
    @Binding var value: Bool

    func body(content: Content) -> some View {
        content
            .opacity(value ? 0 : 1)
            .frame(maxWidth: value ? 0 : .infinity)
            .animation(Animation.bounce.delay(if: !value, 0.6))
    }
}

struct AnimateSlideIn: ViewModifier {
    @Binding var value: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: value ? 0 : 5)
            .opacity(value ? 1 : 0)
            .animation(Animation.ease.delay(if: value, 0.5))
    }
}

struct AnimateSlideOut: ViewModifier {
    @Binding var value: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: value ? -5 : 0)
            .opacity(value ? 0 : 1)
            .animation(Animation.ease.delay(if: !value, 0.5))
    }
}

struct JournalViewAnimation: ViewModifier {
    @Binding var value: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: value ? 0 : 5)
            .opacity(value ? 1 : 0)
    }
}

// MARK: - View+Extension

extension View {
//    func msk_applyAnimationStyle(_ animationStyle: MomoAnimationStyle) -> some View {
//    }
}
