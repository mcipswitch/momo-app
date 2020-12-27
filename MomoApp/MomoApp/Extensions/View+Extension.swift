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

    /// Mimics `mask`
    /// - Parameter mask: The input mask.
    /// - Returns: A modified `View` instance masked with the input mask.
    /// - Please see: https://www.raywenderlich.com/7589178-how-to-create-a-neumorphic-design-with-swiftui
    func inverseMask<Mask>(_ mask: Mask) -> some View where Mask: View {
        self.mask(mask
          .foregroundColor(.black)
          .background(Color.white)
          .compositingGroup()
          .luminanceToAlpha()
        )
      }

    // MARK: - Conditional Modifiers

    /// Apply a conditional modifier.
    /// - Parameters:
    ///   - condition: Apply a modifier only if condition is met.
    ///   - modifier: The modifier to be applied.
    /// - Returns: A modified `View` instance
    /// - Please see: https://swiftui-lab.com/view-extensions-for-better-code-readability/
    public func conditionalModifier<T>(_ condition: Bool, _ modifier: T) -> some View where T: ViewModifier {
        Group {
            if condition {
                self.modifier(modifier)
            } else { self }
        }
    }

    /// Apply trueModifier if condition is met, or falseModifier if not.
    /// - Parameters:
    ///   - condition: Condition to be met.
    ///   - trueModifier: The modifier to be applied if condition is met.
    ///   - falseModifier: The modifier to be applied if condition is not met.
    /// - Returns: A modified `View` instance
    /// - Please see: https://swiftui-lab.com/view-extensions-for-better-code-readability/
    public func conditionalModifier<M1, M2>(_ condition: Bool, _ trueModifier: M1, _ falseModifier: M2) -> some View where M1: ViewModifier, M2: ViewModifier {
        Group {
            if condition {
                self.modifier(trueModifier)
            } else {
                self.modifier(falseModifier)
            }
        }
    }
}

// MARK: - Momo-Specific

extension View {
    func withSpringAnimation(completion: () -> Void) {
        return withAnimation(.spring(), completion)
    }

    /// Make the whole stack tappable.
    func tappable() -> some View {
        return contentShape(Rectangle())
    }


    /// Mask the entire view.
    func maskEntireView() -> some View {
        return mask(Rectangle())
    }

    /// Round rect corners.
    func roundedRect(_ cornerRadius: CGFloat) -> some View {
        return clipShape(RoundedRectangle(cornerRadius: cornerRadius,
                                          style: .continuous))
    }

    /// Disable keyboard avoidance
    func ignoresKeyboard() -> some View {
        return ignoresSafeArea(.keyboard)
    }
}
