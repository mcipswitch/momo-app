//
//  Test.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-11.
//

import SwiftUI

struct AnimatableGradientTest: AnimatableModifier {

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

//        for i in 0..<from.count {
//            gColors.append(colorMixer(c1: from[i], c2: to[i], pct: pct))
//        }

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

// MARK: - Extension

extension Array where Element: UIColor {
    func inter(percentage: CGFloat) -> Color {
        let percentage = Swift.max(Swift.min(percentage, 100), 0) / 100
        switch percentage {
        case 0: return Color(first ?? .clear)
        case 1: return Color(last ?? .clear)
        default:
            let approxIndex = percentage / (1 / CGFloat(count - 1))
            let firstIndex = Int(approxIndex.rounded(.down))
            let secondIndex = Int(approxIndex.rounded(.up))

            let firstColor = self[firstIndex]
            let secondColor = self[secondIndex]

            let c1 = firstColor.rgbComponents
            let c2 = secondColor.rgbComponents

            let intermediatePercentage = approxIndex - CGFloat(firstIndex)

            let uiColor = UIColor(red: CGFloat(c1.red + (c2.red - c1.red) * intermediatePercentage),
                                  green: CGFloat(c1.green + (c2.green - c1.green) * intermediatePercentage),
                                  blue: CGFloat(c1.blue + (c2.blue - c1.blue) * intermediatePercentage),
                                  alpha: CGFloat(c1.alpha + (c2.alpha - c1.alpha) * intermediatePercentage))

            return Color(uiColor)
        }
    }
}
