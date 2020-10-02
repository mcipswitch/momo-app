//
//  MomoLink.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-25.
//

import SwiftUI

struct MomoTextLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.momo.opacity(
                                configuration.isPressed ? pressedOpacity : 1
            ))
            .linkText()
    }
}
