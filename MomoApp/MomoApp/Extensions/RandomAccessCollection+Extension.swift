//
//  RandomAccessCollection+Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-22.
//

import SwiftUI

extension RandomAccessCollection {
    func indexed() -> Array<(offset: Int, element: Element)> {
        Array(enumerated())
    }
}
