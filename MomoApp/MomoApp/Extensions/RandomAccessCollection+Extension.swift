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

// MARK: - Optional+Extension

extension Optional {
    var orNilText: String {
        switch self {
        case .some(let value):
            return String(describing: value)
        case _:
            return "(nil)"
        }
    }
}
