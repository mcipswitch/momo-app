//
//  Modifiers.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-18.
//

import SwiftUI

struct MomoText: ViewModifier {
    var size: CGFloat
    var opacity: Double
    func body(content: Content) -> some View {
        content
            .font(.custom("DMSans-Bold", size: size))
            .foregroundColor(Color.white.opacity(opacity))
            .multilineTextAlignment(.center)
        //.lineSpacing(4)
    }
}

struct MomoTextRegular: ViewModifier {
    var textStyle: MomoTextStyle
    func body(content: Content) -> some View {
        content
            .font(.custom(textStyle.font, size: textStyle.size))
            .foregroundColor(Color.white.opacity(textStyle.opacity))
            .multilineTextAlignment(.center)
    }
}

//struct CalendarMonthText: ViewModifier {
//    var size: CGFloat
//    func body(content: Content) -> some View {
//        content
//            .font(.custom("DMSans-Bold", size: size))
//            .foregroundColor(.white)
//    }
//}

struct MomoButtonText: ViewModifier {
    var size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("DMSans-Bold", size: size))
    }
}

// MARK: - Helpers

enum MomoTextStyle {
    case date, toolbarButton, toolbarTitle, link
    var size: CGFloat {
        switch self {
        case .date, .link, .toolbarTitle: return 16
        case .toolbarButton: return 22
        }
    }
    var opacity: Double {
        switch self {
        case .date: return 0.6
        default: return 1
        }
    }
    var font: String {
        switch self {
        case .link, .toolbarTitle: return "DMSans-Bold"
        default: return "DMSans-Medium"
        }
    }
}

// MARK: - Animations

struct AnimateSlideIn: ViewModifier {
    @Binding var observedValue: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: observedValue ? -5 : 0)
            .opacity(observedValue ? 0 : 1)
            .animation(Animation
                        .ease()
                        .delay(if: !observedValue, 0.5)
            )
    }
}

struct AnimateSlideOut: ViewModifier {
    @Binding var observedValue: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: observedValue ? 0 : 5)
            .opacity(observedValue ? 1 : 0)
            .animation(Animation
                        .ease()
                        .delay(if: observedValue, 0.5)
            )
    }
}
