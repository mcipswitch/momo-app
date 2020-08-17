//
//  Arc.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-16.
//

import SwiftUI

struct Arc: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    path.addArc(
                        center: CGPoint(x: geometry.size.width/2, y: geometry.size.width/2),
                        radius: geometry.size.width/2,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: 90),
                        clockwise: true
                    )
                }
                .stroke(Color.blue, lineWidth: 2)
            }
        }
    }
}

struct Arc_Previews: PreviewProvider {
    static var previews: some View {
        Arc()
    }
}
