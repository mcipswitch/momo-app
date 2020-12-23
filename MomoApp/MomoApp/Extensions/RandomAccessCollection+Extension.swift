//
//  RandomAccessCollection+Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-22.
//

import SwiftUI

extension RandomAccessCollection {
    /// A wrapper that provides both index and element via subscript.
    /// - Returns: Index and element of the collection.
    /// Please see: https://swiftwithmajid.com/2019/12/04/must-have-swiftui-extensions/
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
