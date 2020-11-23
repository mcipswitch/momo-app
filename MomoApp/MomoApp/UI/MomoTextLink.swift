//
//  MomoTextLink.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-23.
//

import SwiftUI

enum MomoTextLink {
    case pastEntries
    var text: String {
        switch self {
        case .pastEntries:
            return "See your past entries"
        }
    }
}

struct MomoTextLinkButton: View {
    var link: MomoTextLink
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(link.text).underline()
        }
        .momoTextLinkStyle()
    }
}

struct MomoTextLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.momo.opacity(
                configuration.isPressed ? pressedOpacity : 1
            ))
            .momoTextRegular(textStyle: .link)
    }
}

// MARK: - Extensions

extension View {
    func momoTextLinkStyle() -> some View {
        return self.buttonStyle(MomoTextLinkStyle())
    }
}

extension ButtonStyle {
    var pressedOpacity: Double { 0.5 }
}
