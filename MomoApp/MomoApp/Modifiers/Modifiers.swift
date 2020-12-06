//
//  Modifiers.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-18.
//

import SwiftUI

struct MomoText: ViewModifier {
    var textStyle: MomoTextStyle
    func body(content: Content) -> some View {
        content
            .font(.custom(textStyle.font.rawValue, size: textStyle.size))
            .foregroundColor(textStyle.color.opacity(textStyle.opacity))
            .multilineTextAlignment(.center)
            .lineSpacing(4)
    }
}

// MARK: - Helpers

enum MomoTextStyle {
    case date, toolbarButton, toolbarTitle, link, button, main, doneMessage
    case graphWeekday, graphDay
    var size: CGFloat {
        switch self {
        case .doneMessage:
            return 32
        case .main, .toolbarButton:
            return 22
        case .date, .link, .toolbarTitle:
            return 16
        case .button, .graphDay:
            return 14
        case .graphWeekday:
            return 12
        }
    }
    var opacity: Double {
        switch self {
        case .date: return 0.6
        case .graphWeekday: return 0.4
        default: return 1
        }
    }
    var font: FontWeight {
        switch self {
        case .link, .toolbarTitle, .button, .main, .graphWeekday, .graphDay, .doneMessage:
            return .bold
        default:
            return .medium
        }
    }
    var color: Color {
        switch self {
        case .button: return .black
        default: return .white
        }
    }
}

enum FontWeight: String {
    case medium = "DMSans-Medium"
    case bold = "DMSans-Bold"
}

// MARK: - Animations

struct AnimateHomeState: ViewModifier {
    @Binding var observedValueForSlideIn: Bool
    @Binding var observedValueForSlideOut: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: self.observedValueForSlideIn ? (!self.observedValueForSlideOut ? 0 : 0) : -5)
            .opacity(self.observedValueForSlideIn ? (!self.observedValueForSlideOut ? 1 : 1) : 0)
            .animation(
                Animation
                    .ease()
                    .delay(if: self.observedValueForSlideIn, (!self.observedValueForSlideOut ? 0.5 : 0))
            )
    }
}

struct AnimateTextFieldBorder: ViewModifier {
    @Binding var observedValueForSlideIn: Bool
    @Binding var observedValueForSlideOut: Bool

    func body(content: Content) -> some View {
        content
            .opacity(self.observedValueForSlideIn ? (!self.observedValueForSlideOut ? 1 : 0) : 0)
            .frame(maxWidth: self.observedValueForSlideIn ? (!self.observedValueForSlideOut ? .infinity : 0) : 0)
            .animation(
                Animation
                    .bounce()
                    .delay(if: self.observedValueForSlideIn, (!self.observedValueForSlideOut ? 0.6 : 0))
            )
    }
}

struct AnimateSlideIn: ViewModifier {
    @Binding var observedValue: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: observedValue ? 0 : 5)
            .opacity(observedValue ? 1 : 0)
            .animation(Animation.ease().delay(if: observedValue, 0.5))
    }
}

struct Slide: ViewModifier {
    @Binding var observedValue: Bool
    func body(content: Content) -> some View {
        content
            .offset(y: observedValue ? 0 : 5)
            .opacity(observedValue ? 1 : 0)
    }
}

// MARK: - Shadows

struct Shadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.6), radius: 20, x: 4, y: 4)
    }
}
