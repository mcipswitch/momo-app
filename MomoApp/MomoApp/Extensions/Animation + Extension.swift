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

    public static func resist() -> Animation {
        return self.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)
    }
    public static func bounce() -> Animation {
        return self.interpolatingSpring(stiffness: 180, damping: 16)
    }
    public static func ease() -> Animation {
        return self.easeInOut(duration: 0.2)
    }
    public static func breathe() -> Animation {
        return self.timingCurve(0.4, 0, 0.4, 1, duration: 4)
    }
}
