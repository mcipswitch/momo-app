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
}
