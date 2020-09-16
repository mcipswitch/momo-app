//
//  Arc.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-16.
//

import SwiftUI

struct ArcShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.maxY),
                    radius: rect.width/2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 180),
                    clockwise: true)
        return path
    }
}

struct Arc_Previews: PreviewProvider {
    static var previews: some View {
        ArcShape()
    }
}






//ZStack(alignment: .top) {
//    ZStack {
//        Rectangle()
//            .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2549019608, green: 0.2039215686, blue: 0.4823529412, alpha: 1)), Color(#colorLiteral(red: 0.01568627451, green: 0.01176470588, blue: 0.07058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
//            .clipShape(
//                ArcShape().offset(y: 6)
//            )
//        // Arc: Track Layer
//        ArcShape()
//            .stroke(Color.black.opacity(0.2), lineWidth: 12)
//        // Arc: Progress Layer
//        ArcShape()
//            .trim(from: 0, to: isLongPressed ? 0.001 : intensity)
//            .stroke(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.6039215686, green: 0.9411764706, blue: 0.8823529412, alpha: 1)), Color(#colorLiteral(red: 0.1882352941, green: 0.8039215686, blue: 0.6156862745, alpha: 1))]), startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 12, lineCap: .round))
//            .shadow(color: Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)), radius: 5, x: 0, y: 0)
//            .rotation3DEffect(
//                Angle(degrees: 180),
//                axis: (x: 0, y: 1, z: 0)
//            )
//            .animation(Animation.easeOut(duration: 0.2))
//    }
//    .frame(height: geometry.size.width/2 + 6)
//    .scaleEffect(1.05)
//
//    CircleButton(forceValue: $forceValue, maxForceValue: $maxForceValue)
//        .padding(.top, 50)
