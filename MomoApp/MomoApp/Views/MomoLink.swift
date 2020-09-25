//
//  MomoLink.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-25.
//

import SwiftUI

struct MomoLink: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)).opacity(configuration.isPressed ? 0.4 : 1))
            .linkText()
    }
}
