//
//  AddMoodViewLogic.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-12.
//

import SwiftUI

// MARK: - JournalGraphViewLogic

struct GraphViewLogic {
    var columnLayout: (CGFloat, Int) -> [GridItem] = { (spacing, count) -> [GridItem] in
        Array(
            repeating: .init(.flexible(), spacing: spacing),
            count: count)
    }
}

// MARK: - AddMoodViewLogic

struct AddMoodViewLogic {

    /// Activate the corresponding color wheel section.
    /// - Parameter degrees: The angle of the joystick in degrees.
    /// - Returns: A `ColorWheelSection` instance.
    func activateColorWheelSection(degrees: CGFloat) -> MSK.ColorWheelSection {
        switch degrees {
        case 0..<120: return .momo
        case 120..<240: return .momoPurple
        case 240..<360: return .momoOrange
        default: return .momo
        }
    }

    /// Calculate the blob value.
    /// - Parameter degrees: The angle of the joystick in degrees.
    func calculateBlobValue(degrees: CGFloat) -> CGFloat {
        switch degrees {
        case 0...60: return (degrees + 300) / 360
        default: return (degrees - 60) / 360
        }
    }
}
