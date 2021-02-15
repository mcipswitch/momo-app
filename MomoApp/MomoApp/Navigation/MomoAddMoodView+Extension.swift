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

// test
struct SlideIn: ViewModifier {
    @Binding var value: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: value ? 0 : 5)
            .opacity(value ? 1 : 0)
            .animation(Animation.ease, value: value)
    }
}

// test
struct SlideOut: ViewModifier {
    @Binding var value: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: value ? -5 : 0)
            .opacity(value ? 0 : 1)
            .animation(Animation.ease, value: value)
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

    // test
    func slideIn(value: Binding<Bool>) -> some View {
        return modifier(SlideIn(value: value))
    }

    func slideOut(value: Binding<Bool>) -> some View {
        return modifier(SlideIn(value: value))
    }
}

// MARK: - AddMoodViewLogic

struct AddMoodViewLogic {

    /// Activate the corresponding color wheel section.
    /// - Parameter degrees: The angle of the joystick in degrees.
    /// - Returns: A `ColorWheelSection` instance.
    static func colorWheelSection(_ degrees: CGFloat) -> ColorWheelSection {
        switch degrees {
        case 0..<120: return .momo
        case 120..<240: return .momoPurple
        case 240..<360: return .momoOrange
        default: return .momo
        }
    }

    /// Calculate the blob value.
    /// - Parameter degrees: The angle of the joystick in degrees.
    static func blobValue(_ degrees: CGFloat) -> CGFloat {
        switch degrees {
        case 0...60: return (degrees + 300) / 360
        default: return (degrees - 60) / 360
        }
    }
}
