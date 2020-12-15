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

    func body(content: Content) -> some View {
        content
            .font(textStyle.font)
            .foregroundColor(textStyle.color.opacity(textStyle.opacity))
            .multilineTextAlignment(.center)
            .lineSpacing(4)
    }
}

// MARK: - View+Extensions

extension View {
    func msk_applyStyle(_ textStyle: MomoTextStyle) -> some View {
        return self.modifier(MomoText(textStyle: textStyle))
    }
}

// MARK: - Font+Extensions

extension Font {
    static func mediumFont(size: CGFloat) -> Font {
        return Font.custom("DMSans-Medium", size: size)
    }

    static func boldFont(size: CGFloat) -> Font {
        return Font.custom("DMSans-Bold", size: size)
    }

    static let mainMessageFont = boldFont(size: 22)
    static let mainDateFont = mediumFont(size: 16)
    static let standardLinkFont = boldFont(size: 16)
    static let standardButtonFont = boldFont(size: 14)
    static let toolbarIconButtonFont = mediumFont(size: 22)
    static let toolbarTitleFont = boldFont(size: 16)
    static let graphWeekdayDetailFont = boldFont(size: 12)
    static let graphDayDetailFont = boldFont(size: 14)
}

// MARK: - Helpers

enum MomoTextStyle {
    case mainMessageFont
    case mainDateFont
    case standardLinkFont
    case standardButtonFont
    case toolbarIconButtonFont
    case toolbarTitleFont
    case graphWeekdayDetailFont
    case graphDayDetailFont

    var font: Font {
        switch self {
        case .mainMessageFont:
            return .mainMessageFont
        case .mainDateFont:
            return .mainDateFont
        case .standardLinkFont:
            return .standardLinkFont
        case .standardButtonFont:
            return .standardButtonFont
        case .toolbarIconButtonFont:
            return .toolbarIconButtonFont
        case .toolbarTitleFont:
            return .toolbarTitleFont
        case .graphWeekdayDetailFont:
            return .graphWeekdayDetailFont
        case .graphDayDetailFont:
            return .graphDayDetailFont
        }
    }

    var opacity: Double {
        switch self {
        case .mainDateFont:
            return 0.6
        case .graphWeekdayDetailFont:
            return 0.4
        default:
            return 1.0
        }
    }

    var color: Color {
        switch self {
        case .standardButtonFont:
            return .black
        default:
            return .white
        }
    }
}



enum MomoLabelStyle {
    case active
    case inactive
}
