//
//  Arc.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-16.
//

import SwiftUI

struct ArcShape: Shape {
    var startAngle: Angle = Angle(degrees: 180)
    var endAngle: Angle = Angle(degrees: 0)
    let lineWidth: CGFloat = 12
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.maxY),
                    radius: rect.width/2,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false)
        return path
    }
}

struct Arc_Previews: PreviewProvider {
    static var previews: some View {
        ArcShape()
    }
}
