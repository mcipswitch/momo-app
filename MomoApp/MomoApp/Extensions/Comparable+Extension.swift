//
//  Comparable+Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-24.
//

import Foundation

extension Comparable {
    func clamp(low: Self, high: Self) -> Self {
        if (self > high) {
            return high
        } else if (self < low) {
            return low
        }

        return self
    }
}
