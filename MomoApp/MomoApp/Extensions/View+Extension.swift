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

    // MARK: - Text Modifiers

    func momoTextBold(size: CGFloat = 22, opacity: Double = 1) -> some View {
        return self.modifier(MomoText(size: size, opacity: opacity))
    }
    func momoTextRegular(size: CGFloat = 22, opacity: Double = 1) -> some View {
        return self.modifier(MomoTextRegular(size: size, opacity: opacity))
    }
    func calendarMonthText(size: CGFloat = 16) -> some View {
        return self.modifier(CalendarMonthText(size: size))
    }
    func dateText(opacity: Double = 1) -> some View {
        return self.modifier(DateText(opacity: opacity))
    }
    func linkText() -> some View {
        return self.modifier(LinkText())
    }
    func momoButtonText(size: CGFloat) -> some View {
        return self.modifier(MomoButtonText(size: size))
    }
}
