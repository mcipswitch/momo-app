//
//  NextButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

// MARK: - MomoButton

struct MomoButton: View {
    let button: MSK.ButtonType
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
    let button: MSK.ButtonType
    var isActive: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .msk_applyButtonStyle(ButtonStyleKit())
            .msk_applyTextStyle(.standardButtonFont)
            .foregroundColor(.momo)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .frame(width: buttonStyle.w, height: buttonStyle.h)
            .background(Color.momo)
            .cornerRadius(buttonStyle.cornerRadius)
            .opacity(isActive ? buttonStyle.activeOpacity : buttonStyle.inactiveOpacity)

            // TODO: - add this later
            //.opacity(configuration.isPressed ? pressedOpacity : 1)
    }
}

// MARK: - View+Extension

extension View {
    func msk_applyMomoButtonStyle(button: MSK.ButtonType, isActive: Bool = true) -> some View {
        return self.buttonStyle(MomoButtonStyle(button: button, isActive: isActive))
    }
}
