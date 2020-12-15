//
//  CGFloat + Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-14.
//

import SwiftUI

extension CGFloat {
    var degrees: CGFloat {
        return self * CGFloat(180 / Double.pi)
    }
}
