//
//  CGPoint + Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-16.
//

import SwiftUI

extension CGPoint {
    /// Calculate the distance to another point.
    /// - Parameter point: A `CGPoint`.
    /// - Returns: The distance in CGFloat.
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow((point.x - x), 2) + pow((point.y - y), 2))
    }

    /// Calculate the angle to another point.
    /// - Parameter point: A `CGPoint`.
    /// - Returns: The angle in degrees.
    /// - Please see: https://stackoverflow.com/questions/6064630/get-angle-from-2-positions
    func angle(to point: CGPoint) -> CGFloat {
        let originX = point.x - self.x
        let originY = point.y - self.y
        let bearingRadians = atan2f(Float(originY), Float(originX))
        var bearingDegrees = CGFloat(bearingRadians).degrees - 30
        while bearingDegrees < 0 {
            bearingDegrees += 360
        }
        return bearingDegrees
    }

    /// Calculate how curved the bezier line should be.
    /// - Parameters:
    ///   - point: A `CGPoint`.
    ///   - lineRadius: Value within 0...1 range used to determine how curved the bezier line should be.
    /// - Returns: The curve offset for x axis.
    func curveXOffset(to point: CGPoint, lineRadius: CGFloat) -> CGFloat {
        /// Calculate delta between current and previous point.
        let deltaX = point.x - self.x
        let curveXOffset = deltaX * lineRadius
        return curveXOffset
    }
}
