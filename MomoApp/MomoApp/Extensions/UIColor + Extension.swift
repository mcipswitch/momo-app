import UIKit
import SwiftUI

// https://qvik.com/news/building-swiftui-design-system-colors-typography-iconography-animation/

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

    public static let blobColorArray: [UIColor] = [#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1), #colorLiteral(red: 0.7333333333, green: 0.1215686275, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.7333333333, blue: 0.1215686275, alpha: 1), #colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)]

    // Deprecated
    public static let gradientMomo: [UIColor] = [#colorLiteral(red: 0.568627451, green: 0.9882352941, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.4156862745, green: 0.8666666667, blue: 0.8039215686, alpha: 1), #colorLiteral(red: 0.3568627451, green: 0.6823529412, blue: 0.9490196078, alpha: 1)]
    public static let gradientPurple: [UIColor] = [#colorLiteral(red: 0.8588235294, green: 0.2745098039, blue: 0.7568627451, alpha: 1), #colorLiteral(red: 0.7882352941, green: 0.2823529412, blue: 0.8274509804, alpha: 1), #colorLiteral(red: 0.7137254902, green: 0.2941176471, blue: 0.8980392157, alpha: 1)]
    public static let gradientOrange: [UIColor] = [#colorLiteral(red: 0.968627451, green: 0.8549019608, blue: 0.5921568627, alpha: 1), #colorLiteral(red: 0.8196078431, green: 0.8588235294, blue: 0.4705882353, alpha: 1), #colorLiteral(red: 0.6941176471, green: 0.8392156863, blue: 0.4431372549, alpha: 1)]
}

extension Color {
    public static let momo = Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1))
    public static let momoPurple = Color(#colorLiteral(red: 0.7333333333, green: 0.1215686275, blue: 1, alpha: 1))
    public static let momoOrange = Color(#colorLiteral(red: 1, green: 0.7333333333, blue: 0.1215686275, alpha: 1))
    public static let momoShadow = Color(#colorLiteral(red: 0.03921568627, green: 0.03921568627, blue: 0.1294117647, alpha: 1))
    public static let momoBackgroundLight = Color(#colorLiteral(red: 0.2588235294, green: 0.2039215686, blue: 0.5019607843, alpha: 1))
    public static let momoBackgroundDark = Color(#colorLiteral(red: 0.1098039216, green: 0.09411764706, blue: 0.2509803922, alpha: 1))
}

extension Gradient {
    static let momoTriColorGradient = Gradient(colors: [Color.momo,
                                                      Color.momoPurple,
                                                      Color.momoOrange,
                                                      Color.momo
    ])

    static let colorRingGradient = Gradient(colors: [Color(#colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 1, alpha: 1)),
                                                     Color(#colorLiteral(red: 0.7960784314, green: 0.5411764706, blue: 1, alpha: 1)),
                                                     Color(#colorLiteral(red: 0.431372549, green: 0.4901960784, blue: 0.9843137255, alpha: 1))
    ])

    static let momoRingGradient = Gradient(colors: [.momo])

    static let graphLineGradient = Gradient(colors: [Color.gray.opacity(0.4),
                                                     Color.gray.opacity(0)
    ])

    static let momoBackgroundGradient = Gradient(colors: [.momoBackgroundLight,
                                                          .momoBackgroundDark
    ])
}

// MARK: - LinearGradient+Extension

extension LinearGradient {

    enum GradientDirection {
        typealias DirectionTuple = (startPoint: UnitPoint, endPoint: UnitPoint)

        case vertical, diagonal

        var point: DirectionTuple {
            switch self {
            case .vertical: return DirectionTuple(.bottom, .top)
            case .diagonal: return DirectionTuple(.topLeading, .bottomTrailing)
            }
        }
    }

    init(_ gradient: Gradient, direction: GradientDirection) {
        self.init(gradient: gradient,
                  startPoint: direction.point.startPoint,
                  endPoint: direction.point.endPoint)
    }
}
