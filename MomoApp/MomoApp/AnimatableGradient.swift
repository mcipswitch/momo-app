//
//  AnimatableGradient.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-15.
//

import SwiftUI

/**
 Animate gradient fills.
 Please see: https://swiftui-lab.com/swiftui-animations-part3/
 */
struct AnimatableGradient: AnimatableModifier {

    /// Both `to` and `from` color arrays should contain the same number of colors.
    let from: [UIColor]
    let to: [UIColor]
    var pct: CGFloat = 0
    
    let startRadius: CGFloat
    let endRadius: CGFloat
    
    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }
    
    func body(content: Content) -> some View {
        var gColors = [Color]()
        
        for i in 0..<from.count {
            gColors.append(colorMixer(c1: from[i], c2: to[i], pct: pct))
        }
        
        return Rectangle()
            .fill(RadialGradient(gradient: Gradient(colors: gColors),
                                 center: .topLeading,
                                 startRadius: startRadius,
                                 endRadius: endRadius))
    }
    
    // Basic implementation of a color interpolation between two values.
    func colorMixer(c1: UIColor, c2: UIColor, pct: CGFloat) -> Color {
        guard let cc1 = c1.cgColor.components else { return Color(c1) }
        guard let cc2 = c2.cgColor.components else { return Color(c2) }
        
        let r = (cc1[0] + (cc2[0] - cc1[0]) * pct)
        let g = (cc1[1] + (cc2[1] - cc1[1]) * pct)
        let b = (cc1[2] + (cc2[2] - cc1[2]) * pct)
        
        return Color(red: Double(r), green: Double(g), blue: Double(b))
    }
}
