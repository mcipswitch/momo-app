//
//  AddMoodViewLogic.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-12.
//

import SwiftUI

// MARK: - AddMoodViewLogic

struct AddMoodViewLogic {

    /// Activate the corresponding color wheel section.
    /// - Parameter degrees: The angle of the joystick in degrees.
    /// - Returns: `ColorWheelSection`
    func activateColorWheelSection(degrees: CGFloat) -> Momo.ColorWheelSection {
        switch degrees {
        case 0..<120:
            return .momo
        case 120..<240:
            return .momoPurple
        case 240..<360:
            return .momoOrange
        default:
            return .momo
        }
    }

    /// Calculate the blob value.
    /// - Parameter degrees: The angle of the joystick in degrees.
    func calculatePct(degrees: CGFloat) -> CGFloat {
        switch degrees {
        case 0...60:
            return (degrees + 300) / 360
        default:
            return (degrees - 60) / 360
        }
    }
}

// MARK: - Momo Design System

struct Momo {
    public static let defaultButtonSize: CGFloat = 80

    // MARK: Button
    enum Button {
        typealias SizeTuple = (w: CGFloat, h: CGFloat)

        case done
        case standard, joystick

        var size: SizeTuple {
            switch self {
            case .done: return SizeTuple(90, 34)
            case .standard: return SizeTuple(230, 60)
            case .joystick: return SizeTuple(80, 80)
            }
        }

        var imageName: String {
            switch self {
            case .done: return "arrow.right"
            default: return ""
            }
        }
    }

    // MARK: ToolbarButton
    enum ToolbarButton {
        case back, list, graph

        var imageName: String {
            switch self {
            case .back: return "chevron.backward"
            case .list: return "list.bullet"
            case .graph: return "chart.bar.xaxis"
            }
        }

        var title: String {
            switch self {
            case .list: return NSLocalizedString("All entries", comment: "")
            case .graph: return NSLocalizedString("Last 7 days", comment: "")
            default: return ""
            }
        }
    }

    // MARK: ToolbarButton
    enum Link {
        case pastEntries

        var text: String {
            switch self {
            case .pastEntries: return NSLocalizedString("See your past entries", comment: "")
            }
        }
    }

    // MARK: ColorWheelSection
    enum ColorWheelSection {
        case momo, momoPurple, momoOrange

        var degrees: Double {
            switch self {
            case .momo: return 0
            case .momoPurple: return 120
            case .momoOrange: return 240
            }
        }
    }

    // MARK: EntryState
    enum EntryState {
        case add, edit

        var text: String {
            switch self {
            case .add: return NSLocalizedString("Add today's emotion", comment: "")
            case .edit: return NSLocalizedString("Edit today's emotion", comment: "")
            }
        }
    }
}
