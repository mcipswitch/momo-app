//
//  MomoLinkButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-23.
//

import SwiftUI

// MARK: - MomoTextLinkButton

struct MomoLinkButton: View {
    var link: Link
    var action: () -> Void

    init(_ link: Link, action: @escaping () -> Void) {
        self.link = link
        self.action = action
    }

    var body: some View {
        Button(link: link, action: action)
            .msk_applyMomoLinkStyle()
    }
}

// MARK: - MomoTextLinkStyle

struct MomoLinkStyle: ButtonStyle {
    @Environment(\.buttonStyleKit) var buttonStyle

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.momo.opacity(
                configuration.isPressed ? buttonStyle.pressedOpacity : 1
            ))
            .msk_applyTextStyle(.standardLinkFont)
    }
}

// MARK: - View+Extension

extension View {
    func msk_applyMomoLinkStyle() -> some View {
        return self.buttonStyle(MomoLinkStyle())
    }
}

// MARK: - Button+Extension

extension Button where Label == Text {
    init(link: Link, action: @escaping () -> Void) {
        self.init(action: action, label: {
            Text(link.text).underline()
        })
    }
}
