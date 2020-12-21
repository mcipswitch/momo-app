//
//  ButtonStyle.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-20.
//

import SwiftUI

// MARK: - ButtonStyleKit

public struct ButtonStyleKit {
    let button: ButtonType
    let isActive: Bool

    let activeOpacity: Double
    let inactiveOpacity: Double
    let pressedOpacity: Double

    var w: CGFloat { button.size.w }
    var h: CGFloat { button.size.h }
    var cornerRadius: CGFloat { return button.size.h / 2 }

    init(
        button: ButtonType = .standard,
        isActive: Bool = true,

        activeOpacity: Double = 1.0,
        inactiveOpacity: Double = 0.2,
        pressedOpacity: Double = 0.5
    ) {
        self.button = button
        self.isActive = isActive

        self.activeOpacity = activeOpacity
        self.inactiveOpacity = inactiveOpacity
        self.pressedOpacity = pressedOpacity
    }
}

// MARK: - ButtonStyleKitEnvironmentKey

struct ButtonStyleKitEnvironmentKey: EnvironmentKey {
    static var defaultValue: ButtonStyleKit = .init()
}

// MARK: - EnvironmentValues+Extensions

extension EnvironmentValues {
    /// An additional environment value that will hold the button style.
    var buttonStyleKit: ButtonStyleKit {
        get { self[ButtonStyleKitEnvironmentKey.self] }
        set { self[ButtonStyleKitEnvironmentKey.self] = newValue }
    }
}

// MARK: - View+Extensions

extension View {
    /// An extension on View protocol that allows us to insert chart styles into a view hierarchy environment.
    func msk_applyButtonStyle(_ style: ButtonStyleKit) -> some View {
        environment(\.buttonStyleKit, style)
    }
}
