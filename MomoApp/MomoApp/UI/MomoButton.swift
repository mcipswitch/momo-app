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
    let button: MSK.ButtonType
    var isActive: Bool = true

    private var w: CGFloat {
        button.size.w
    }

    private var h: CGFloat {
        button.size.h
    }

    private var cornerRadius: CGFloat {
        h / 2
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .msk_applyStyle(.standardButtonFont)
            .foregroundColor(.momo)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .frame(width: w, height: h)
            .background(Color.momo)
            .cornerRadius(cornerRadius)
            .opacity(isActive ? active : inactive)

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
