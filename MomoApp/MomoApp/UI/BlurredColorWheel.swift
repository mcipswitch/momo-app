//
//  BlurredColorWheel.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-17.
//

import SwiftUI

struct BlurredColorWheel: View {
    @Binding var section: ColorWheelSection
    
    var body: some View {
        let gradient = AngularGradient(gradient: .momoTriColorGradient,
                                       center: .center,
                                       angle: .degrees(-90))

        Circle()
            .strokeBorder(gradient, lineWidth: 50)
            .animation(.easeInOut(duration: 1.5))
            .mask(
                Circle()
                    .trim(from: 0.0, to: 1/3)
                    .stroke(gradient, lineWidth: 80)
                    .rotationEffect(Angle(degrees: 210))
                    .rotationEffect(Angle(degrees: self.section.degrees))
            )
            .blur(radius: 40)
    }
}
