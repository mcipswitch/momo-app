//
//  BlurredColorWheel.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-17.
//

import SwiftUI

// MARK: - BlurredColorWheel

struct BlurredColorWheel: View {
    @Binding var isActive: Bool
    @Binding var section: Momo.ColorWheelSection
    
    var body: some View {
        let gradient = Gradient(colors: [Color.momo, Color.momoPurple, Color.momoOrange, Color.momo])
        let ring = AngularGradient(gradient: gradient,
                                    center: .center,
                                    angle: .degrees(-90))
        Circle()
            .strokeBorder(ring, lineWidth: 50)
            .opacity(isActive ? 1 : 0)
            .animation(.easeInOut(duration: 1.5))
            .mask(
                Circle()
                    .trim(from: 0.0, to: 1/3)
                    .stroke(ring, lineWidth: 80)
                    .rotationEffect(Angle(degrees: 210))
                    .rotationEffect(Angle(degrees: self.section.degrees))
            )
            .blur(radius: 40)
    }
}
