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
    /// - Please see: https://swiftwithmajid.com/2019/12/04/must-have-swiftui-extensions/
    public func indexed() -> Array<(offset: Int, element: Element)> {
        Array(enumerated())
    }
}
