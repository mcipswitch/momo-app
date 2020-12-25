//
//  Optional+Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-25.
//

import Foundation

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
