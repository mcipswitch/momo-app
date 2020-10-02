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
}

extension Color {
    public static let momo = Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1))
    public static let momoPurple = Color(#colorLiteral(red: 0.7333333333, green: 0.1215686275, blue: 1, alpha: 1))
    public static let momoOrange = Color(#colorLiteral(red: 1, green: 0.7333333333, blue: 0.1215686275, alpha: 1))
}
