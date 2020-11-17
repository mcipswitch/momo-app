import UIKit
import SwiftUI

extension UIColor {

    static func fromHexString(_ hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        let r,g,b: CGFloat
        let offset = hexString.hasPrefix("#") ? 1: 0
        let start = hexString.index(hexString.startIndex, offsetBy: offset)
        let hexColor = String(hexString[start...])
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        if scanner.scanHexInt64(&hexNumber) {
            r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            b = CGFloat(hexNumber & 0x0000ff) / 255
            return UIColor(red: r, green: g, blue: b, alpha: alpha)
        }
        return UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
    }

    public static let gradientMomo: [UIColor] = [#colorLiteral(red: 0.78, green: 1, blue: 0.934, alpha: 1), #colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1), #colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)]
    public static let gradientPurple: [UIColor] = [#colorLiteral(red: 0.9921568627, green: 0.9960784314, blue: 0.8, alpha: 1), #colorLiteral(red: 0.9960784314, green: 0.4745098039, blue: 0.6078431373, alpha: 1), #colorLiteral(red: 0.7333333333, green: 0.1215686275, blue: 1, alpha: 1)]
    public static let gradientOrange: [UIColor] = [#colorLiteral(red: 1, green: 0.9019607843, blue: 0.8196078431, alpha: 1), #colorLiteral(red: 1, green: 0.6705882353, blue: 0.5411764706, alpha: 1), #colorLiteral(red: 1, green: 0.7333333333, blue: 0.1215686275, alpha: 1)]
}

extension Color {
    public static let momo = Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1))
    public static let momoPurple = Color(#colorLiteral(red: 0.7333333333, green: 0.1215686275, blue: 1, alpha: 1))
    public static let momoOrange = Color(#colorLiteral(red: 1, green: 0.7333333333, blue: 0.1215686275, alpha: 1))
}

extension Gradient {
    public static let backgroundGradient = Gradient(colors: [Color(#colorLiteral(red: 0.2588235294, green: 0.2039215686, blue: 0.5019607843, alpha: 1)), Color(#colorLiteral(red: 0.1098039216, green: 0.09411764706, blue: 0.2509803922, alpha: 1))])
}

extension RadialGradient {
    public static let momo = RadialGradient(gradient: Gradient.backgroundGradient,
                                            center: .center,
                                            startRadius: 10,
                                            endRadius: 500)
}
