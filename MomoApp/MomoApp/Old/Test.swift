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
        let cArray: [[UIColor]] = [c1, c2, c3, c1]
        let gColors = cArray.inter(percentage: self.pct)

        return Rectangle()
            .fill(RadialGradient(gradient: Gradient(colors: gColors),
                                 center: .topLeading,
                                 startRadius: startRadius,
                                 endRadius: endRadius))
//            .fill(LinearGradient(gradient: Gradient(colors: gColors),
//                                 startPoint: .topLeading,
//                                 endPoint: .bottomTrailing))
    }
}

// MARK: - Extension

extension Array where Element == [UIColor] {
    func inter(percentage: CGFloat) -> [Color] {
        let percentage = Swift.max(Swift.min(percentage, 1), 0)
        switch percentage {
        case 0: return [Color(#colorLiteral(red: 0.568627451, green: 0.9882352941, blue: 0.9960784314, alpha: 1)), Color(#colorLiteral(red: 0.4156862745, green: 0.8666666667, blue: 0.8039215686, alpha: 1)), Color(#colorLiteral(red: 0.3568627451, green: 0.6823529412, blue: 0.9490196078, alpha: 1))]
        case 1: return [Color(#colorLiteral(red: 0.568627451, green: 0.9882352941, blue: 0.9960784314, alpha: 1)), Color(#colorLiteral(red: 0.4156862745, green: 0.8666666667, blue: 0.8039215686, alpha: 1)), Color(#colorLiteral(red: 0.3568627451, green: 0.6823529412, blue: 0.9490196078, alpha: 1))]
        default:
            let approxIndex = percentage / (1 / CGFloat(count - 1))
            let firstIndex = Int(approxIndex.rounded(.down))
            let secondIndex = Int(approxIndex.rounded(.up))

            let ca1 = self[firstIndex]
            let ca2 = self[secondIndex]

            /// Array of gradient colors
            var gColors = [Color]()
            let intermediatePercentage = approxIndex - CGFloat(firstIndex)

            for i in 0..<ca1.count {
                gColors.append(self.colorMixer(c1: ca1[i], c2: ca2[i], pct: intermediatePercentage))
            }

            return gColors
        }
    }

    private func colorMixer(c1: UIColor, c2: UIColor, pct: CGFloat) -> Color {
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

// MARK: - Previews

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 0) {
            VStack(alignment: .center, spacing: 2) {
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.0, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.025, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.05, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.075, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.1, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.125, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.15, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.175, startRadius: 0, endRadius: 250))
            }
            VStack(alignment: .center, spacing: 2) {
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.2, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.225, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.25, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.275, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.3, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.325, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.35, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.375, startRadius: 0, endRadius: 250))
            }
            VStack(alignment: .center, spacing: 2) {
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.4, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.425, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.45, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.475, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.5, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.525, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.55, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.575, startRadius: 0, endRadius: 250))
            }
            VStack(alignment: .center, spacing: 2) {
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.6, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.625, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.65, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.675, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.7, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.725, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.75, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.775, startRadius: 0, endRadius: 250))
            }
            VStack(alignment: .center, spacing: 2) {
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.8, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.825, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.85, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.875, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.9, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.925, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.95, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 0.927, startRadius: 0, endRadius: 250))
                Rectangle().modifier(AnimatableGradientTest(c1: UIColor.gradientMomo, c2: UIColor.gradientPurple, c3: UIColor.gradientOrange, pct: 1.0, startRadius: 0, endRadius: 250))
            }
        }
    }
}
