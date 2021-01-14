//
//  String+Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-23.
//

import Foundation

extension String {
    public var isNotEmpty: Bool {
        !self.isEmpty
    }

    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    func applyCharLimit(_ limit: Int) -> String {
        return String(self.prefix(limit))
    }
}
