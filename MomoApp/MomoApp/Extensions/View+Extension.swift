//
//  View+Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-17.
//

import SwiftUI

extension View {

    /// Calls the completion handler whenever an animation on the given value completes.
    /// - Parameters:
    ///   - value: The value to observe for animations.
    ///   - completion: The completion callback to call once the animation completes.
    /// - Returns: A modified `View` instance with the observer attached.
    func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> ModifiedContent<Self, AnimationCompletionObserverModifier<Value>> {
        return modifier(AnimationCompletionObserverModifier(observedValue: value, completion: completion))
    }

    func slideIn(if value: Binding<Bool>) -> some View {
        return modifier(AnimateSlideIn(observedValue: value))
    }

    func slideOut(if value: Binding<Bool>) -> some View {
        return modifier(AnimateSlideOut(observedValue: value))
    }

    // MARK: - Text Modifiers

    func momoTextBold(size: CGFloat = 22, opacity: Double = 1) -> some View {
        return self.modifier(MomoText(size: size, opacity: opacity))
    }
    func momoTextRegular(textStyle: MomoTextStyle) -> some View {
        return self.modifier(MomoTextRegular(textStyle: textStyle))
    }
//    func calendarMonthText(size: CGFloat = 16) -> some View {
//        return self.modifier(CalendarMonthText(size: size))
//    }
    func momoButtonText(size: CGFloat) -> some View {
        return self.modifier(MomoButtonText(size: size))
    }
}
