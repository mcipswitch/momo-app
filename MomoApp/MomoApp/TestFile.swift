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

        var from = [UIColor]()
        var to = [UIColor]()

        switch pct {
        case 0..<0.33:
            from = UIColor.gradientMomo
            to = UIColor.gradientPurple
        case 0.33..<0.66:
            from = UIColor.gradientPurple
            to = UIColor.gradientOrange
        case 0.66...1:
            from = UIColor.gradientOrange
            to = UIColor.gradientMomo
        default:
            break
        }

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
        let cc1 = c1.hsbComponents
        let cc2 = c2.hsbComponents

        let hue = (cc1.hue + (cc2.hue - cc1.hue) * pct)
        let brightness = (cc1.brightness + (cc2.brightness - cc1.brightness) * pct)
        let alpha = (cc1.alpha + (cc2.alpha - cc1.alpha) * pct)
        let saturation = (cc1.saturation + (cc2.saturation - cc1.saturation) * pct)

        let uiColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        return Color(uiColor)
    }
}
