//
//  MomoButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

// MARK: - MomoButton

struct MomoButton: View {
    let button: ButtonType
    let action: () -> Void
    @Binding var isActive: Bool
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(button.text)
                Image(systemName: button.imageName)
            }
        }
        .msk_applyMomoButtonStyle(button: button, isActive: isActive)
        .disabled(!isActive)
    }
}

// MARK: - MomoButtonStyle

struct MomoButtonStyle: ButtonStyle {
    @Environment(\.buttonStyleKit) var buttonStyle
    let button: ButtonType
    var isActive: Bool = true

    private var w: CGFloat { button.size.w }
    private var h: CGFloat { button.size.h }
    private var cornerRadius: CGFloat { return button.size.h / 2 }

    private var buttonIsJoystick: Bool {
        return button == .standard || button == .joystick
    }

    private var isDone: Bool {
        return button == .done
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .msk_applyButtonStyle(ButtonStyleKit())
            .msk_applyTextStyle(.standardButtonFont)
            .foregroundColor(.momo)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .frame(width: w, height: h)
            .background(Color.momo)
            .cornerRadius(cornerRadius)
            .opacity(isActive ? buttonStyle.activeOpacity : buttonStyle.inactiveOpacity)

            // Activate isPressed opacity if the button is not the joystick
            .opacity(buttonIsJoystick ? 1 :
                        configuration.isPressed
                        ? buttonStyle.pressedOpacity
                        : 1
            )

            // TODO: fix Glow
            // .shadow(color: .momo, radius: 4)
    }
}

// MARK: - View+Extension

extension View {
    func msk_applyMomoButtonStyle(button: ButtonType, isActive: Bool = true) -> some View {
        return self.buttonStyle(MomoButtonStyle(button: button, isActive: isActive))
    }
}
