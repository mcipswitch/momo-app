//
//  MomoLinkButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-23.
//

import SwiftUI

// MARK: - MomoTextLinkStyle

struct MomoLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.momo.opacity(
                configuration.isPressed ? 0.5 : 1
            ))
            .momoText(.standardLinkFont)
    }
}

// MARK: - View+Extension

extension View {
    func momoLinkStyle() -> some View {
        return self.buttonStyle(MomoLinkStyle())
    }
}

// MARK: - Button+Extension

extension Button where Label == Text {
    init(textLink: String, action: @escaping () -> Void) {
        self.init(action: action, label: {
            Text(textLink).underline()
        })
    }
}
