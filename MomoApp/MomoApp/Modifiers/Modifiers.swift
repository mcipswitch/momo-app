//
//  Modifiers.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-18.
//

import SwiftUI

// MARK: - MomoText

struct MomoText: ViewModifier {
    var textStyle: MomoTextStyle
    var font: Font {
        switch textStyle {
        case .appMain: return .appMain
        case .appDate: return .appDate
        case .appLink: return .appLink
        case .appButtonText: return .appButtonText
        case .appToolbarButton: return .appToolbarButton
        case .appToolbarTitle: return .appToolbarTitle
        case .appGraphWeekday: return .appGraphWeekday
        case .appGraphDay: return .appGraphDay
        }
    }
    func body(content: Content) -> some View {
        content
            .font(self.font)
            .foregroundColor(self.textStyle.color
                                .opacity(self.textStyle.opacity)
            )
            .multilineTextAlignment(.center)
            .lineSpacing(4)
    }
}

// MARK: - View+Extensions

extension View {
    func momoText(_ textStyle: MomoTextStyle) -> some View {
        return self.modifier(MomoText(textStyle: textStyle))
    }
}

// MARK: - Font+Extensions

enum AppFontWeight {
    case medium, bold
}

extension Font {
    static func appFont(size: CGFloat, weight: AppFontWeight) -> Font {
        switch weight {
        case .medium:
            return Font.custom("DMSans-Medium", size: size)
        case .bold:
            return Font.custom("DMSans-Bold", size: size)
        }
    }

    static let appMain = appFont(size: 22, weight: .bold)
    static let appDate = appFont(size: 16, weight: .medium)
    static let appLink = appFont(size: 16, weight: .bold)
    static let appButtonText = appFont(size: 14, weight: .bold)

    static let appToolbarButton = appFont(size: 22, weight: .medium)
    static let appToolbarTitle = appFont(size: 16, weight: .bold)

    static let appGraphWeekday = appFont(size: 12, weight: .bold)
    static let appGraphDay = appFont(size: 14, weight: .bold)
}

// MARK: - Helpers

enum MomoTextStyle {
    case appMain, appDate, appLink, appButtonText,appToolbarButton,appToolbarTitle, appGraphWeekday, appGraphDay

    var opacity: Double {
        switch self {
        case .appDate: return 0.6
        case .appGraphWeekday: return 0.4
        default: return 1
        }
    }
    var color: Color {
        switch self {
        case .appButtonText: return .black
        default: return .white
        }
    }
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
