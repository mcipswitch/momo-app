//
//  JoystickStyle.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-20.
//

import SwiftUI

// MARK: - JoystickStyle

public struct JoystickStyle {
    let radius: CGFloat
    let ringBlurRadius: CGFloat
    let ringLineWidth: CGFloat
    let ringScaleEffect: CGFloat

    var ringRadius: CGFloat {
        self.radius + 16
    }

    public init(
        radius: CGFloat = 80,
        ringBlurRadius: CGFloat = 2,
        ringLineWidth: CGFloat = 6,
        ringScaleEffect: CGFloat = 1.1
    ) {
        self.radius = radius
        self.ringBlurRadius = ringBlurRadius
        self.ringLineWidth = ringLineWidth
        self.ringScaleEffect = ringScaleEffect
    }
}

// MARK: - ButtonStyleKitEnvironmentKey

struct JoystickStyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: JoystickStyle = .init()
}

// MARK: - EnvironmentValues+Extensions

extension EnvironmentValues {
    /// An additional environment value that will hold the line chart style.
    var joystickStyle: JoystickStyle {
        get { self[JoystickStyleEnvironmentKey.self] }
        set { self[JoystickStyleEnvironmentKey.self] = newValue }
    }
}

// MARK: - View+Extensions

extension View {
    /// An extension on View protocol that allows us to insert chart styles into a view hierarchy environment.
    func msk_applyJoystickStyle(_ style: JoystickStyle) -> some View {
        environment(\.joystickStyle, style)
    }
}
