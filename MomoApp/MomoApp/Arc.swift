//
//  Arc.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-16.
//

import SwiftUI

struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
//        let rotationAdjustment = Angle.degrees(90)
//        let modifiedStart = startAngle - rotationAdjustment
//        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.maxY), radius: rect.width/2, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        return path
    }
}

struct Arc_Previews: PreviewProvider {
    static var previews: some View {
        Arc(startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 180), clockwise: true)
            .stroke(Color.blue, lineWidth: 10)
    }
}
