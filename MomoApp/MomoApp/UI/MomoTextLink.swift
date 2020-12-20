//
//  MomoTextLink.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-23.
//

import SwiftUI

// MARK: - MomoTextLinkButton

struct MomoLinkButton: View {
    var link: MSK.Link
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(link.text)
                .underline()
        }
        .msk_applyMomoLinkStyle()
    }
}

// MARK: - MomoTextLinkStyle

struct MomoLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.momo.opacity(
                configuration.isPressed ? pressed : 1
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
