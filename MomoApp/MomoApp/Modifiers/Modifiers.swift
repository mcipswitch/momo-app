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
    var size: CGFloat
    var opacity: Double
    func body(content: Content) -> some View {
        content
            .font(.custom("DMSans-Medium", size: size))
            .foregroundColor(Color.white.opacity(opacity))
            .multilineTextAlignment(.center)
    }
}

struct CalendarMonthText: ViewModifier {
    var size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("DMSans-Bold", size: size))
            .foregroundColor(.white)
    }
}

struct DateText: ViewModifier {
    var opacity: Double
    func body(content: Content) -> some View {
        content
            .font(.custom("DMSans-Medium", size: 16))
            .foregroundColor(Color.white.opacity(opacity))
    }
}

struct MomoButtonText: ViewModifier {
    var size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("DMSans-Bold", size: size))
    }
}

struct LinkText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("DMSans-Bold", size: 16))
            .foregroundColor(Color.momo)
    }
}

// MARK: - Backgrounds

struct MomoBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RadialGradient(gradient: .momoBackgroundGradient,
                               center: .center,
                               startRadius: 10,
                               endRadius: 500)
            )
    }
}

// MARK: - Animations

struct SlideIn: ViewModifier {
    @Binding var observedValue: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: observedValue ? -5 : 0)
            .opacity(observedValue ? 0 : 1)
            .animation(Animation
                        .ease()
                        .delay(if: !observedValue, 0.5)

                       // Not sure what this accomplishes
                       //.delay(showHome ? 0 : (noDelay ? 0 : 0.5))
            )
    }
}

struct SlideOut: ViewModifier {
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
