//
//  Animation + Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-28.
//

import SwiftUI

extension Animation {
    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
    
    func delay(if expression: Bool, _ delay: Double) -> Animation {
        return self.delay(expression ? delay : 0)
    }
    
    // MARK: - Custom

    /// Creates a resisting band animation effect.
    /// - Returns: An `Animation` instance.
    public static func resist() -> Animation {
        return self.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)
    }

    /// Creates a spring bouncing animation effect.
    /// - Returns: An `Animation` instance.
    public static func bounce() -> Animation {
        return self.interpolatingSpring(stiffness: 180, damping: 16)
    }

    /// Creates a standard ease in out animation effect.
    /// - Returns: An `Animation` instance.
    public static func ease() -> Animation {
        return self.easeInOut(duration: 0.2)
    }

    /// Creates a breathing animation effect.
    /// - Returns: An `Animation` instance.
    public static func breathe() -> Animation {
        return self.timingCurve(0.4, 0, 0.4, 1, duration: 4)
    }

    /// Creates a cascading animation effect.
    /// - Parameter offset: The timing offset between the individual elements.
    /// - Returns: An `Animation` instance.
    public static func cascade(offset: Double) -> Animation {
        return self.easeInOut(duration: 0.8)
            .delay(offset * 0.05)
    }
}
