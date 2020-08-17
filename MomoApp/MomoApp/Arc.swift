//
//  Arc.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-16.
//

import SwiftUI

struct Arc: Shape {
    var startAngle: Angle = Angle(degrees: 0)
    var endAngle: Angle = Angle(degrees: 180)
    var clockwise: Bool = true
    var lineWidth: CGFloat = 12
    
    func path(in rect: CGRect) -> Path {
//        let rotationAdjustment = Angle.degrees(90)
//        let modifiedStart = startAngle - rotationAdjustment
//        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.minY + rect.width/2 + lineWidth/2), radius: rect.width/2, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        return path
    }
}

struct Arc_Previews: PreviewProvider {
    static var previews: some View {
        Arc()
    }
}
