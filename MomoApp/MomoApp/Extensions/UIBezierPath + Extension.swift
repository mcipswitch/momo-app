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
    static var blob3: UIBezierPath {
        let shape = UIBezierPath()
        shape.move(to: CGPoint(x: 45.8, y: -79.4))
        shape.addCurve(to: CGPoint(x: 77.6, y: -45), controlPoint1: CGPoint(x: 59.2, y: -71.6), controlPoint2: CGPoint(x: 69.9, y: -59.1))
        shape.addCurve(to: CGPoint(x: 89.6, y: -0.3), controlPoint1: CGPoint(x: 85.4, y: -31), controlPoint2: CGPoint(x: 90.2, y: -15.5))
        shape.addCurve(to: CGPoint(x: 75.4, y: 43.9), controlPoint1: CGPoint(x: 89, y: 14.8), controlPoint2: CGPoint(x: 83, y: 29.6))
        shape.addCurve(to: CGPoint(x: 45.9, y: 80.4), controlPoint1: CGPoint(x: 67.8, y: 58.3), controlPoint2: CGPoint(x: 58.8, y: 72.2))
        shape.addCurve(to: CGPoint(x: 0.8, y: 89.8), controlPoint1: CGPoint(x: 33.1, y: 88.6), controlPoint2: CGPoint(x: 16.6, y: 91.2))
        shape.addCurve(to: CGPoint(x: -42.6, y: 74.8), controlPoint1: CGPoint(x: -15, y: 88.5), controlPoint2: CGPoint(x: -29.9, y: 83.1))
        shape.addCurve(to: CGPoint(x: -74, y: 42.3), controlPoint1: CGPoint(x: -55.3, y: 66.5), controlPoint2: CGPoint(x: -65.7, y: 55.2))
        shape.addCurve(to: CGPoint(x: -89.4, y: -0.6), controlPoint1: CGPoint(x: -82.3, y: 29.3), controlPoint2: CGPoint(x: -88.4, y: 14.7))
        shape.addCurve(to: CGPoint(x: -78.7, y: -45.9), controlPoint1: CGPoint(x: -90.4, y: -15.8), controlPoint2: CGPoint(x: -86.1, y: -31.5))
        shape.addCurve(to: CGPoint(x: -46.8, y: -80.9), controlPoint1: CGPoint(x: -71.2, y: -60.2), controlPoint2: CGPoint(x: -60.5, y: -73.2))
        shape.addCurve(to: CGPoint(x: -0.2, y: -90.7), controlPoint1: CGPoint(x: -33.1, y: -88.5), controlPoint2: CGPoint(x: -16.6, y: -91))
        shape.addCurve(to: CGPoint(x: 45.8, y: -79.4), controlPoint1: CGPoint(x: 16.2, y: -90.3), controlPoint2: CGPoint(x: 32.4, y: -87.2))
        shape.close()
        return shape
    }
    static var blob4: UIBezierPath {
        let shape = UIBezierPath()
        shape.move(to: CGPoint(x: 44.5, y: -76.1))
        shape.addCurve(to: CGPoint(x: 80, y: -46), controlPoint1: CGPoint(x: 58.8, y: -69), controlPoint2: CGPoint(x: 72, y: -59.1))
        shape.addCurve(to: CGPoint(x: 89.8, y: -0.5), controlPoint1: CGPoint(x: 88, y: -32.8), controlPoint2: CGPoint(x: 90.6, y: -16.4))
        shape.addCurve(to: CGPoint(x: 77.3, y: 45.2), controlPoint1: CGPoint(x: 88.9, y: 15.4), controlPoint2: CGPoint(x: 84.5, y: 30.9))
        shape.addCurve(to: CGPoint(x: 46.4, y: 79.8), controlPoint1: CGPoint(x: 70, y: 59.5), controlPoint2: CGPoint(x: 59.8, y: 72.7))
        shape.addCurve(to: CGPoint(x: 0.2, y: 87.5), controlPoint1: CGPoint(x: 33.1, y: 86.9), controlPoint2: CGPoint(x: 16.5, y: 87.8))
        shape.addCurve(to: CGPoint(x: -45.2, y: 78.2), controlPoint1: CGPoint(x: -16.2, y: 87.2), controlPoint2: CGPoint(x: -32.3, y: 85.6))
        shape.addCurve(to: CGPoint(x: -75.9, y: 43.8), controlPoint1: CGPoint(x: -58.1, y: 70.9), controlPoint2: CGPoint(x: -67.7, y: 57.8))
        shape.addCurve(to: CGPoint(x: -91.8, y: -0.6), controlPoint1: CGPoint(x: -84.1, y: 29.8), controlPoint2: CGPoint(x: -90.8, y: 14.9))
        shape.addCurve(to: CGPoint(x: -79.6, y: -45.4), controlPoint1: CGPoint(x: -92.8, y: -16.1), controlPoint2: CGPoint(x: -88.2, y: -32.2))
        shape.addCurve(to: CGPoint(x: -44.5, y: -76.3), controlPoint1: CGPoint(x: -71, y: -58.6), controlPoint2: CGPoint(x: -58.4, y: -69.1))
        shape.addCurve(to: CGPoint(x: -0.1, y: -87.7), controlPoint1: CGPoint(x: -30.6, y: -83.6), controlPoint2: CGPoint(x: -15.3, y: -87.8))
        shape.addCurve(to: CGPoint(x: 44.5, y: -76.1), controlPoint1: CGPoint(x: 15.2, y: -87.5), controlPoint2: CGPoint(x: 30.3, y: -83.2))
        shape.close()
        return shape
    }
    
}
