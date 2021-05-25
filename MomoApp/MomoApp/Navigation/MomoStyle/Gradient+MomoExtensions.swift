//
//  Gradient+MomoExtensions.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2021-05-23.
//

import SwiftUI

struct MomoGradient {
    var colors: [Color]
}

extension MomoGradient {
    /// e.g. line chart data
    static var triColor: Self {
        return .init(colors: [Color.momo,
                              Color.momoPurple,
                              Color.momoOrange,
                              Color.momo])
    }

    /// Gradient for the app background
    static var standardBackground: Self {
        return .init(colors: [.momoBackgroundLight,
                              .momoBackgroundDark])
    }

    // MARK: Line Graph

    static var lineGraph: Self {
        return .init(colors: [Color.gray.opacity(0.4),
                              Color.gray.opacity(0)])
    }

    // MARK: Joystick

    static var joystickColorRing: Self {
        return .init(colors: [Color(#colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 1, alpha: 1)),
                              Color(#colorLiteral(red: 0.7960784314, green: 0.5411764706, blue: 1, alpha: 1)),
                              Color(#colorLiteral(red: 0.431372549, green: 0.4901960784, blue: 0.9843137255, alpha: 1))])
    }

    static var joystickMomoRing: Self {
        return .init(colors: [.momo])
    }
}

extension Gradient {
    static func momo(_ gradient: MomoGradient) -> Gradient {
        Gradient(colors: gradient.colors)
    }
}
