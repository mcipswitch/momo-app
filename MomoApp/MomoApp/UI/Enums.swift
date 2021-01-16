//
//  Enums.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-12.
//

import SwiftUI

// MARK: - JournalType

enum JournalType {
    case list
    case chart

    var title: String {
        switch self {
        case .list:
            return "All entries".localized
        case .chart:
            return "Last 7 days".localized
        }
    }
}

// MARK: - ButtonType

enum ButtonType {
    typealias SizeTuple = (w: CGFloat, h: CGFloat)

    case done, doneConfirmed
    case standard, joystick

    var text: String {
        switch self {
        case .done, .doneConfirmed:
            return "Done".localized
        default:
            return ""
        }
    }

    var size: SizeTuple {
        switch self {
        case .done, .doneConfirmed:
            return SizeTuple(90, 34)
        case .standard:
            return SizeTuple(230, 60)
        case .joystick:
            return SizeTuple(80, 80)
        }
    }

    var imageName: String {
        switch self {
        case .done:
            return "arrow.right"
        case .doneConfirmed:
            return "checkmark"
        default: return ""
        }
    }
}

// MARK: - ToolbarButton

enum ToolbarButton {
    case backButton
    case list
    case graph

    var imageName: String {
        switch self {
        case .backButton:
            return "chevron.backward"
        case .list:
            return "list.bullet"
        case .graph:
            return "chart.bar.xaxis"
        }
    }
}

// MARK: - Link

enum Link {
    case pastEntries

    var text: String {
        switch self {
        case .pastEntries:
            return "See your past entries".localized
        }
    }
}

// MARK: - ColorWheelSection

enum ColorWheelSection {
    case momo
    case momoPurple
    case momoOrange

    var degrees: Double {
        switch self {
        case .momo:
            return 0
        case .momoPurple:
            return 120
        case .momoOrange:
            return 240
        }
    }
}

// MARK: - Status

enum Status {
    case add
    case edit(emotion: String)
    case done(emotion: String)

    var text: String {
        switch self {
        case .add: return "Add today's emotion".localized
        case .edit: return "Edit today's emotion".localized
        default: return ""
        }
    }
}
