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
            .lineSpacing(4)
    }
}

struct DateText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("DMSans-Medium", size: 16))
            .foregroundColor(Color.white.opacity(0.6))
    }
}

struct MomoButtonText: ViewModifier {
    var size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("DMSans-Bold", size: size))
    }
}

struct AccentText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("DMSans-Bold", size: 16))
            .foregroundColor(Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)))
    }
}

// Animations
struct SlideIn: ViewModifier {
    @Binding var showHome: Bool
    @Binding var noDelay: Bool
    func body(content: Content) -> some View {
        content
            .offset(y: showHome ? -5 : 0)
            .opacity(showHome ? 0 : 1)
            .animation(Animation
                        .easeInOut(duration: 0.2)
                        .delay(showHome ? 0 : (noDelay ? 0 : 0.5))
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
                        .easeInOut(duration: 0.2)
                        .delay(showHome ? 0.5 : 0)
            )
    }
}

// MARK: - View + Extensions
extension View {
    func momoText(opacity: Double = 1) -> some View {
        return self.modifier(MomoText(opacity: opacity))
    }
    func dateText() -> some View {
        return self.modifier(DateText())
    }
    func momoButtonText(size: CGFloat) -> some View {
        return self.modifier(MomoButtonText(size: size))
    }
}

// MARK: - Text + Extension
extension Text {
    func underlineText() -> some View {
        return self.underline().modifier(AccentText())
    }
}
