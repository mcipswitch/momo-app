//
//  Path+Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-18.
//

import SwiftUI

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
