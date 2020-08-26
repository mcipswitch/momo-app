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
