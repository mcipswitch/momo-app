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

    /// Calculates the angle from this point to another point.
    /// - Parameter point: A `CGPoint`.
    /// - Returns: The angle in degrees.
    /// Please see: https://stackoverflow.com/questions/6064630/get-angle-from-2-positions
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

    /// Calculates how curved the bezier line should be.
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

extension Path {
    /// Adds a cubic Bézier curve to the path, with the specified curved x offset, end point and control points.
    /// - Parameters:
    ///   - curveXOffset: The curve offset for x axis to set how curved the bezier curve should be.
    mutating func addCurve(to point: CGPoint, previous: CGPoint, curveXOffset: CGFloat) {
        /// Control point with offset to right.
        let control1 = CGPoint(x: previous.x + curveXOffset, y: previous.y)
        /// Control point with offset to left.
        let control2 = CGPoint(x: point.x - curveXOffset, y: point.y)

        self.addCurve(to: point, control1: control1, control2: control2)
    }
}
