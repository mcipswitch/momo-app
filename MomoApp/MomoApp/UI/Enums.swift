//
//  Enums.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-12.
//

import SwiftUI

enum ButtonType {
    typealias SizeTuple = (w: CGFloat, h: CGFloat)

    case done
    case standard, joystick

    var text: String {
        switch self {
        case .done: return NSLocalizedString("Done", comment: "")
        default: return ""
        }
    }

    var size: SizeTuple {
        switch self {
        case .done: return SizeTuple(90, 34)
        case .standard: return SizeTuple(230, 60)
        case .joystick: return SizeTuple(80, 80)
        }
    }

    var imageName: String {
        switch self {
        case .done:
            return "arrow.right"
        default:
            return ""
        }
    }
}

// MARK: - ToolbarButton

enum ToolbarButton {
    case back
    case list
    case graph

    var imageName: String {
        switch self {
        case .back:
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
            return NSLocalizedString("See your past entries", comment: "")
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

// MARK: - EntryState

enum EntryState {
    case add, edit

    var text: String {
        switch self {
        case .add: return NSLocalizedString("Add today's emotion", comment: "")
        case .edit: return NSLocalizedString("Edit today's emotion", comment: "")
        }
    }
}