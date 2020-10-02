//
//  RainbowRing.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-17.
//

import SwiftUI

struct RainbowRing: View {
    @Binding var isActive: Bool
    @Binding var degrees: Double
    
    var body: some View {
        let spectrum = Gradient(colors: [Color.momo, Color.momoPurple, Color.momoOrange, Color.momo])
        let conic = AngularGradient(gradient: spectrum,
                                    center: .center,
                                    angle: .degrees(-90))
        
        Circle()
            .stroke(conic, lineWidth: 50)
            .opacity(isActive ? 1 : 0)
            .animation(Animation
                        .easeInOut(duration: 1.5)
            )
            .mask(
                Circle()
                    .trim(from: 0.0, to: 1/3)
                    .stroke(conic, lineWidth: 40)
                    .rotationEffect(Angle(degrees: 210))
                    .rotationEffect(Angle(degrees: degrees))
            )
            .blur(radius: 50)
            .frame(width: 180)
    }
}

struct RainbowRing_Previews: PreviewProvider {
    static var previews: some View {
        RainbowRing(isActive: .constant(true), degrees: .constant(90))
    }
}
