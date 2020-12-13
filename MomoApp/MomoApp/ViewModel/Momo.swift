//
//  Momo.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-12.
//

import SwiftUI

// MARK: - Momo Design System

struct Momo {
    static let defaultJoystickSize: CGFloat = 80

    struct Journal {}
    struct Joystick {}
    struct TextField {}

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

extension Momo.Journal {
    static var listLayout: [GridItem] { [GridItem(.flexible())] }

    struct Graph {
        static let selectionLineWidth: CGFloat = 4
        static let spacing: CGFloat = 8
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

extension Momo.TextField {
    static let charLimit: Int = 20

    struct Border {
        static let height: CGFloat = 2
    }
}
