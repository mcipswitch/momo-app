//
//  AnimatableColor.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-15.
//

import SwiftUI

// MARK: - AnimatableColor

/**
 Animate colors in gradient

 Please see:
 https://swiftui-lab.com/swiftui-animations-part3/
 https://stackoverflow.com/questions/15032562/ios-find-color-at-point-between-two-colors/59996029#59996029
 */
struct AnimatableColor: AnimatableModifier {

    let colors: [UIColor]
    var pct: CGFloat

    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }

    func body(content: Content) -> some View {
        let color = self.colors.intermediate(percentage: self.pct * 100)

        return Rectangle()
            .foregroundColor(color)
    }
}

// MARK: - Extension

extension Array where Element: UIColor {
    func intermediate(percentage: CGFloat) -> Color {
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

// MARK: - Previews

struct TestFile_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 0) {
            VStack(alignment: .center, spacing: 2) {
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.0))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.1))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.15))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.2))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.25))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.3))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.35))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.4))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.45))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.5))
            }
            VStack(alignment: .center, spacing: 2) {
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.55))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.6))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.65))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.7))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.75))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.8))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.85))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.9))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 0.95))
                Rectangle().modifier(AnimatableColor(colors: UIColor.blobColorArray, pct: 1.0))
            }
        }
    }
}
