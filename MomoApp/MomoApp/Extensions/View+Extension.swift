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

    func animateHomeState(inValue: Binding<Bool>, outValue: Binding<Bool>) -> some View {
        return modifier(AnimateHomeState(observedValueForSlideIn: inValue, observedValueForSlideOut: outValue))
    }

    func animateTextFieldBorder(inValue: Binding<Bool>, outValue: Binding<Bool>) -> some View {
        return modifier(AnimateTextFieldBorder(observedValueForSlideIn: inValue, observedValueForSlideOut: outValue))
    }

    func slideInAnimation(if value: Binding<Bool>) -> some View {
        return modifier(AnimateSlideIn(observedValue: value))
    }

    func slide(if value: Binding<Bool>) -> some View {
        return modifier(Slide(observedValue: value))
    }

    // MARK: - Shadow

    func shadow() -> some View {
        return self.modifier(Shadow())
    }

    /// Mimics `mask`
    /// - Parameter mask: The input mask.
    /// - Returns: A modified `View` instance masked with the input mask.
    /// - Reference: https://www.raywenderlich.com/7589178-how-to-create-a-neumorphic-design-with-swiftui
    func inverseMask<Mask>(_ mask: Mask) -> some View where Mask: View {
        self.mask(mask
          .foregroundColor(.black)
          .background(Color.white)
          .compositingGroup()
          .luminanceToAlpha()
        )
      }
}
