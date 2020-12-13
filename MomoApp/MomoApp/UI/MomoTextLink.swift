//
//  MomoTextLink.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-23.
//

import SwiftUI

// MARK: - MomoTextLinkButton

struct MomoLinkButton: View {
    var link: Momo.Link
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(link.text).underline()
        }
        .momoLinkStyle()
    }
}

// MARK: - MomoTextLinkStyle

struct MomoLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.momo.opacity(
                configuration.isPressed ? pressedOpacity : 1
            ))
            .momoText(.appLink)
    }
}

// MARK: - Extensions

extension View {
    func momoLinkStyle() -> some View {
        return self.buttonStyle(MomoLinkStyle())
    }
}

extension ButtonStyle {
    var pressedOpacity: Double { 0.5 }
    var inactiveOpacity: Double { 0.2 }
}

extension View {
    var placeHolderOpacity: Double { 0.6 }
}
