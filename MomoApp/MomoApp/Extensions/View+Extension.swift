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

    func animateTextFieldBorder(value: Binding<Bool>) -> some View {
        return modifier(AnimateTextFieldBorder(value: value))
    }

    func slideInAnimation(value: Binding<Bool>) -> some View {
        return modifier(AnimateSlideIn(value: value))
    }

    func slideOutAnimation(value: Binding<Bool>) -> some View {
        return modifier(AnimateSlideOut(value: value))
    }

    func slide(if value: Binding<Bool>) -> some View {
        return modifier(Slide(observedValue: value))
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
