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
    public static let defaultJoystickSize: CGFloat = 80

    struct TextField {}
    struct Joystick {}

    // MARK: Button
    enum Button {
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

extension Momo.TextField {
    static let charLimit: Int = 20
    static let minimumScaleFactor: CGFloat = 0.8

    struct Border {
        static let height: CGFloat = 2
    }
}

extension Momo.Joystick {
    static let defaultSize: CGFloat = 80

    struct Ring {
        static let blur: CGFloat = 2
        static let lineWidth: CGFloat = 6
        static let scaleEffect: CGFloat = 1.1
        static let size: CGFloat = Momo.Joystick.defaultSize + 16
    }
}
