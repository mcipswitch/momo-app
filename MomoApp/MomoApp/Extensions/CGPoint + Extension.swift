//
//  CGPoint + Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-16.
//

import SwiftUI

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow((point.x - x), 2) + pow((point.y - y), 2))
    }
    
    func angle(to point: CGPoint) -> CGFloat {
        let originX = point.x - self.x
        let originY = point.y - self.y
        let bearingRadians = atan2f(Float(originY), Float(originX))
        var bearingDegrees = CGFloat(bearingRadians).degrees - 90
        while bearingDegrees < 0 {
            bearingDegrees += 360
        }
        return bearingDegrees
    }
}
