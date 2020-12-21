//
//  TextFieldStyle.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-20.
//

import SwiftUI

// MARK: - MomoTextFieldStyleKit

public struct TextFieldStyleKit {
    let borderHeight: CGFloat
    let charLimit: Int
    let placeholderOpacity: Double

    var borderCornerRadius: CGFloat {
        self.borderHeight / 2
    }

    public init(
        borderHeight: CGFloat = 2.0,
        charLimit: Int = 20,
        placeholderOpacity: Double = 0.6
    ) {
        self.borderHeight = borderHeight
        self.charLimit = charLimit
        self.placeholderOpacity = placeholderOpacity
    }
}

// MARK: - MomoTextFieldStyleKitEnvironmentKey

struct MomoTextFieldStyleKitEnvironmentKey: EnvironmentKey {
    static var defaultValue: TextFieldStyleKit = .init()
}

// MARK: - EnvironmentValues+Extensions

extension EnvironmentValues {
    /// An additional environment value that will hold the line chart style.
    var textFieldStyle: TextFieldStyleKit {
        get { self[MomoTextFieldStyleKitEnvironmentKey.self] }
        set { self[MomoTextFieldStyleKitEnvironmentKey.self] = newValue }
    }
}

// MARK: - View+Extensions

// NOT USED
extension View {
    /// An extension on View protocol that allows us to insert chart styles into a view hierarchy environment.
    func msk_applyTextFieldStyle(_ style: TextFieldStyleKit) -> some View {
        environment(\.textFieldStyle, style)
    }
}
