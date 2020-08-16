//
//  UIBezierPath+Extension.swift
//  SVGToBezier
//
//  Created by Stewart Lynch on 2020-06-02.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import UIKit

extension UIBezierPath {
    static func calculateBounds(paths: [UIBezierPath]) -> CGRect {
        let myPaths = UIBezierPath()
        for path in paths {
            myPaths.append(path)
        }
        return (myPaths.bounds)
    }
    
    static var blob1: UIBezierPath {
        let shape = UIBezierPath()
        shape.move(to: CGPoint(x: 45.1, y: -79.2))
        shape.addCurve(to: CGPoint(x: 73.4, y: -43.3), controlPoint1: CGPoint(x: 57.8, y: -70.9), controlPoint2: CGPoint(x: 66.9, y: -57.4))
        shape.addCurve(to: CGPoint(x: 84.4, y: 0.3), controlPoint1: CGPoint(x: 79.9, y: -29.2), controlPoint2: CGPoint(x: 83.8, y: -14.6))
        shape.addCurve(to: CGPoint(x: 75.1, y: 43.6), controlPoint1: CGPoint(x: 85, y: 15.3), controlPoint2: CGPoint(x: 82.3, y: 30.6))
        shape.addCurve(to: CGPoint(x: 43.2, y: 74.2), controlPoint1: CGPoint(x: 68, y: 56.5), controlPoint2: CGPoint(x: 56.4, y: 67.1))
        shape.addCurve(to: CGPoint(x: 0.2, y: 84.8), controlPoint1: CGPoint(x: 29.9, y: 81.4), controlPoint2: CGPoint(x: 14.9, y: 85.1))
        shape.addCurve(to: CGPoint(x: -43.4, y: 73.6), controlPoint1: CGPoint(x: -14.6, y: 84.5), controlPoint2: CGPoint(x: -29.2, y: 80.2))
        shape.addCurve(to: CGPoint(x: -80.2, y: 45.5), controlPoint1: CGPoint(x: -57.6, y: 67), controlPoint2: CGPoint(x: -71.5, y: 58.1))
        shape.addCurve(to: CGPoint(x: -92.2, y: 0.2), controlPoint1: CGPoint(x: -88.9, y: 32.8), controlPoint2: CGPoint(x: -92.5, y: 16.4))
        shape.addCurve(to: CGPoint(x: -80, y: -46.4), controlPoint1: CGPoint(x: -91.9, y: -16.1), controlPoint2: CGPoint(x: -87.8, y: -32.2))
        shape.addCurve(to: CGPoint(x: -46.8, y: -80.6), controlPoint1: CGPoint(x: -72.2, y: -60.7), controlPoint2: CGPoint(x: -60.8, y: -73))
        shape.addCurve(to: CGPoint(x: -0.1, y: -90.9), controlPoint1: CGPoint(x: -32.9, y: -88.3), controlPoint2: CGPoint(x: -16.4, y: -91.1))
        shape.addCurve(to: CGPoint(x: 45.1, y: -79.2), controlPoint1: CGPoint(x: 16.2, y: -90.7), controlPoint2: CGPoint(x: 32.5, y: -87.5))
        shape.close()
        return shape
    }
    static var blob2: UIBezierPath {
        let shape = UIBezierPath()
        shape.move(to: CGPoint(x: 45.5, y: -78.6))
        shape.addCurve(to: CGPoint(x: 80, y: -46.1), controlPoint1: CGPoint(x: 59.6, y: -70.6), controlPoint2: CGPoint(x: 72, y: -59.7))
        shape.addCurve(to: CGPoint(x: 91.5, y: 0), controlPoint1: CGPoint(x: 88, y: -32.5), controlPoint2: CGPoint(x: 91.5, y: -16.3))
        shape.addCurve(to: CGPoint(x: 80.3, y: 46.5), controlPoint1: CGPoint(x: 91.5, y: 16.3), controlPoint2: CGPoint(x: 88, y: 32.6))
        shape.addCurve(to: CGPoint(x: 46.2, y: 80.1), controlPoint1: CGPoint(x: 72.5, y: 60.4), controlPoint2: CGPoint(x: 60.3, y: 72))
        shape.addCurve(to: CGPoint(x: 0.3, y: 92.3), controlPoint1: CGPoint(x: 32.1, y: 88.2), controlPoint2: CGPoint(x: 16.1, y: 92.9))
        shape.addCurve(to: CGPoint(x: -44.6, y: 77.7), controlPoint1: CGPoint(x: -15.4, y: 91.8), controlPoint2: CGPoint(x: -30.9, y: 86))
        shape.addCurve(to: CGPoint(x: -77.9, y: 45.1), controlPoint1: CGPoint(x: -58.4, y: 69.4), controlPoint2: CGPoint(x: -70.5, y: 58.5))
        shape.addCurve(to: CGPoint(x: -88.2, y: -0.1), controlPoint1: CGPoint(x: -85.3, y: 31.8), controlPoint2: CGPoint(x: -88.1, y: 15.9))
        shape.addCurve(to: CGPoint(x: -78, y: -44.8), controlPoint1: CGPoint(x: -88.4, y: -16), controlPoint2: CGPoint(x: -85.8, y: -32))
        shape.addCurve(to: CGPoint(x: -43.5, y: -75.4), controlPoint1: CGPoint(x: -70.3, y: -57.7), controlPoint2: CGPoint(x: -57.4, y: -67.3))
        shape.addCurve(to: CGPoint(x: 0.4, y: -90.7), controlPoint1: CGPoint(x: -29.6, y: -83.5), controlPoint2: CGPoint(x: -14.8, y: -90))
        shape.addCurve(to: CGPoint(x: 45.5, y: -78.6), controlPoint1: CGPoint(x: 15.7, y: -91.5), controlPoint2: CGPoint(x: 31.4, y: -86.5))
        shape.close()
        return shape
    }
    
}
