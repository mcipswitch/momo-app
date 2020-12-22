//
//  MiniGraphView+Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-22.
//

import SwiftUI

// MARK: - Preference Keys

struct SelectionPreferenceKey: PreferenceKey {
    static var defaultValue: Value = nil
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue()
    }
}

// MARK: - View+Extension
