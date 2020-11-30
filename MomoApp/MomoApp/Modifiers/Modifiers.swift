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
    case date, toolbarButton, toolbarTitle, link, button, main
    case graphWeekday, graphDay
    var size: CGFloat {
        switch self {
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
        case .link, .toolbarTitle, .button, .main, .graphWeekday, .graphDay:
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

struct AnimateSlideIn: ViewModifier {
    @Binding var observedValue: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: observedValue ? -5 : 0)
            .opacity(observedValue ? 0 : 1)
            .animation(
                Animation.ease()
                    .delay(if: !observedValue, 0.5)
                    //.delay(observedValue ? 0 : (delay ? 0.5 : 0))
            )
    }
}

struct AnimateSlideOut: ViewModifier {
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
