//
//  SizeModifier.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-05.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

/**
 A `ViewModifier` that attaches a geometry reader to a view as a background to read its size.
 Please see: https://swiftwithmajid.com/2020/01/15/the-magic-of-view-preferences-in-swiftui/
*/
struct SizeModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }

    func body(content: Content) -> some View {
        content.background(sizeView)
    }
}
