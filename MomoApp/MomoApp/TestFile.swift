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
 And this: https://gist.github.com/delputnam/21a2f5b6f1aff314b427ff2dd1586852
 */
struct AnimatableColors: AnimatableModifier {

    /// Color arrays should contain the same number of colors
    let c1: [UIColor]
    let c2: [UIColor]
    let c3: [UIColor]

    var pct: CGFloat = 0

    let startRadius: CGFloat
    let endRadius: CGFloat

    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }

    func body(content: Content) -> some View {
        var gColors = [Color]()

        // Color mix c1 and c2
        for i in 0..<c1.count {
            gColors.append(colorMixer(c1: c1[i], c2: c2[i], c3: c3[i], pct: pct))
        }

        return Rectangle()
            .fill(RadialGradient(gradient: Gradient(colors: gColors),
                                 center: .topLeading,
                                 startRadius: startRadius,
                                 endRadius: endRadius))
    }

    // Basic implementation of a color interpolation between two values.
    func colorMixer(c1: UIColor, c2: UIColor, c3: UIColor, pct: CGFloat) -> Color {
        let cc1 = c1.hsbComponents
        let cc2 = c2.hsbComponents
        let cc3 = c3.hsbComponents

        let hue = (cc1.hue + (cc2.hue - cc1.hue) * pct)
        let brightness = (cc1.brightness + (cc2.brightness - cc1.brightness) * pct)
        let alpha = (cc1.alpha + (cc2.alpha - cc1.alpha) * pct)
        let saturation = (cc1.saturation + (cc2.saturation - cc1.saturation) * pct)

        let uiColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        return Color(uiColor)
    }
}
