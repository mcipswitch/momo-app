//
//  Glow.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2021-01-14.
//

import SwiftUI

extension View {
    func glow(_ color: Color = .momo, radius: CGFloat = 6, opacity: Double = 1) -> some View {
        self
            .shadow(color: color, radius: radius)
    }
}
