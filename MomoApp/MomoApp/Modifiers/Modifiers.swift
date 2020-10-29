//
//  Modifiers.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-18.
//

import SwiftUI

struct MomoText: ViewModifier {
    var opacity: Double
    func body(content: Content) -> some View {
        content
            .font(.custom("DMSans-Bold", size: 22))
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

// MARK: - Animations
struct SlideIn: ViewModifier {
    @Binding var showHome: Bool
    @Binding var noDelay: Bool
    func body(content: Content) -> some View {
        content
            .offset(y: showHome ? -5 : 0)
            .opacity(showHome ? 0 : 1)
            .animation(Animation
                        .ease()
                        .delay(if: !showHome, 0.5)
                        //.delay(showHome ? 0 : (noDelay ? 0 : 0.5))
            )
    }
}

struct SlideOut: ViewModifier {
    @Binding var showHome: Bool
    func body(content: Content) -> some View {
        content
            .offset(y: showHome ? 0 : 5)
            .opacity(showHome ? 1 : 0)
            .animation(Animation
                        .ease()
                        .delay(if: showHome, 0.5)
            )
    }
}

// MARK: - View + Extensions
extension View {
    func momoText(opacity: Double = 1) -> some View {
        return self.modifier(MomoText(opacity: opacity))
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

// MARK: - Text + Extension
extension Text {
    func underlineText() -> some View {
        return self.underline().modifier(LinkText())
    }
}
