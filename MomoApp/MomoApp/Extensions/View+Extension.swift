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

    func momoText(_ textStyle: MomoTextStyle) -> some View {
        return self.modifier(MomoText(textStyle: textStyle))
    }
}
