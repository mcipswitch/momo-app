//
//  MomoAddMoodView+Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-24.
//

import SwiftUI

// MARK: - Animations

struct ColorRingAnimation: ViewModifier {
    @Binding var value: Bool

    func body(content: Content) -> some View {
        content
            .animation(Animation.bounce.delay(if: !value, 0.6),
                       value: value)
    }
}

struct AddEmotionButtonAnimation: ViewModifier {
    @Binding var value: Bool

    func body(content: Content) -> some View {
        content
            .animation(Animation.bounce.delay(if: value, 0.2),
                       value: value)
    }
}

struct TextFieldBorderAnimation: ViewModifier {
    @Binding var value: Bool

    func body(content: Content) -> some View {
        content
            .opacity(value ? 0 : 1)
            .frame(maxWidth: value ? 0 : .infinity)
            .animation(Animation.bounce.delay(if: !value, 0.6),
                       value: value)
    }
}

struct AnimateSlideIn: ViewModifier {
    @Binding var value: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: value ? 0 : 5)
            .opacity(value ? 1 : 0)
            .animation(Animation.ease.delay(if: value, 0.5),
                       value: value)
    }
}

struct AnimateSlideOut: ViewModifier {
    @Binding var value: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: value ? -5 : 0)
            .opacity(value ? 0 : 1)
            .animation(Animation.ease.delay(if: !value, 0.5),
                       value: value)
    }
}


// MARK: - View+Extension

extension View {

    func colorRingAnimation(value: Binding<Bool>) -> some View {
        return modifier(ColorRingAnimation(value: value))
    }

    func addEmotionButtonAnimation(value: Binding<Bool>) -> some View {
        return modifier(AddEmotionButtonAnimation(value: value))
    }

    func textFieldBorderAnimation(value: Binding<Bool>) -> some View {
        return modifier(TextFieldBorderAnimation(value: value))
    }

    func slideInAnimation(value: Binding<Bool>) -> some View {
        return modifier(AnimateSlideIn(value: value))
    }

    func slideOutAnimation(value: Binding<Bool>) -> some View {
        return modifier(AnimateSlideOut(value: value))
    }
}
