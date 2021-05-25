//
//  CGFloat+MomoExtensions.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2021-05-23.
//

import SwiftUI

enum MomoSpacing: CGFloat {
    case scale1 = 4
    case scale15 = 6
    case scale2 = 8
    case scale3 = 12
    case scale4 = 16
}

extension CGFloat {
    static func momo(_ spacing: MomoSpacing) -> CGFloat {
        spacing.rawValue
    }
}
