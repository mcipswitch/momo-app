//
//  ActionButtonStyle.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-02.
//

import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white.opacity(
                configuration.isPressed ? pressedOpacity : 1
            ))
            .momoText()
    }
}
