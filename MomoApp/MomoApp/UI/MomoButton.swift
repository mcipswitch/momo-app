//
//  NextButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

// MARK: - Extension

extension View {
    func momoButtonStyle(button: Momo.Button, isActive: Bool = true) -> some View {
        return self.buttonStyle(MomoButtonStyle(button: button, isActive: isActive))
        //return self.buttonStyle(MomoButtonStyle(w: w, h: h, isActive: isActive))
    }
}

// MARK: - MomoButton

struct MomoButton: View {
    @Binding var isActive: Bool
    let button: Momo.Button
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text("Done")
                Image(systemName: button.imageName)
            }
        }
        .momoButtonStyle(button: button, isActive: isActive)
        .disabled(!isActive)
    }
}

// MARK: - MomoButtonStyle

struct MomoButtonStyle: ButtonStyle {
    let button: Momo.Button
    private var w: CGFloat { button.size.w }
    private var h: CGFloat { button.size.h }
    var isActive: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .momoText(.appButtonText)
            .foregroundColor(.momo)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .frame(width: w, height: h)
            .background(Color.momo)
            .cornerRadius(h / 2)
            .opacity(isActive ? 1 : 0.2)

            // TODO: - add this later
            //.opacity(configuration.isPressed ? pressedOpacity : 1)
    }
}

// MARK: - Previews

struct NextButton_Previews: PreviewProvider {
    static var previews: some View {
        MomoButton(isActive: .constant(true), button: .done, action: {})
    }
}
