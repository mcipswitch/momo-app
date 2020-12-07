////
////  AnimatableGradient.swift
////  MomoApp
////
////  Created by Priscilla Ip on 2020-09-15.
////
//
//import SwiftUI
//
///**
// Animate gradient fills.
// Please see: https://swiftui-lab.com/swiftui-animations-part3/
// And this: https://gist.github.com/delputnam/21a2f5b6f1aff314b427ff2dd1586852
// */
//struct AnimatableGradient: AnimatableModifier {
//
//    /// Both `to` and `from` color arrays should contain the same number of colors.
//    let from: [UIColor]
//    let to: [UIColor]
//    var pct: CGFloat = 0
//
//    let startRadius: CGFloat
//    let endRadius: CGFloat
//
//    var animatableData: CGFloat {
//        get { pct }
//        set { pct = newValue }
//    }
//
//    func body(content: Content) -> some View {
//        var gColors = [Color]()
//
//        for i in 0..<from.count {
//            gColors.append(colorMixer(c1: from[i], c2: to[i], pct: pct))
//        }
//
//        return Rectangle()
//            .fill(RadialGradient(gradient: Gradient(colors: gColors),
//                                 center: .topLeading,
//                                 startRadius: startRadius,
//                                 endRadius: endRadius))
//    }
//
//    // Basic implementation of a color interpolation between two values.
//    func colorMixer(c1: UIColor, c2: UIColor, pct: CGFloat) -> Color {
//        let cc1 = c1.hsbComponents
//        let cc2 = c2.hsbComponents
//
//        let hue = (cc1.hue + (cc2.hue - cc1.hue) * pct)
//        let brightness = (cc1.brightness + (cc2.brightness - cc1.brightness) * pct)
//        let alpha = (cc1.alpha + (cc2.alpha - cc1.alpha) * pct)
//        let saturation = (cc1.saturation + (cc2.saturation - cc1.saturation) * pct)
//
//        let uiColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
//        return Color(uiColor)
//    }
//}
//
//// MARK: - UIColor+Extension
//
//extension UIColor {
//    var rgbComponents:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
//        var r:CGFloat = 0
//        var g:CGFloat = 0
//        var b:CGFloat = 0
//        var a:CGFloat = 0
//        if getRed(&r, green: &g, blue: &b, alpha: &a) {
//            return (r,g,b,a)
//        }
//        return (0,0,0,0)
//    }
//    // hue, saturation, brightness and alpha components from UIColor**
//    var hsbComponents:(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
//        var hue:CGFloat = 0
//        var saturation:CGFloat = 0
//        var brightness:CGFloat = 0
//        var alpha:CGFloat = 0
//        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha){
//            return (hue,saturation,brightness,alpha)
//        }
//        return (0,0,0,0)
//    }
//    var htmlRGBColor:String {
//        return String(format: "#%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255))
//    }
//    var htmlRGBaColor:String {
//        return String(format: "#%02x%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255),Int(rgbComponents.alpha * 255) )
//    }
//}
