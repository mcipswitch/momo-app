//
//  CGFloat + Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-14.
//

import SwiftUI

extension CGFloat {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
        let result = ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
        return result
    }
    
    var degrees: CGFloat {
        return self * CGFloat(180 / Double.pi)
    }
}
