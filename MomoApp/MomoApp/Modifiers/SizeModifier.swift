//
//  SizeModifier.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-05.
//

import SwiftUI

// MARK: - SizePrefKey

struct SizePrefData: Equatable {
    let viewID: Int
    let bounds: CGRect
}

struct SizePrefKey: PreferenceKey {
    static var defaultValue: [SizePrefData] = []
    static func reduce(value: inout [SizePrefData], nextValue: () -> [SizePrefData]) {
        value.append(contentsOf: nextValue())
    }
}

extension View {
    public func saveSizes(viewID: Int, coordinateSpace: CoordinateSpace = .global) -> some View {
        /**
         Attach a geometry reader to a view as a background to read its size.

         Please see:
         https://swiftwithmajid.com/2020/01/15/the-magic-of-view-preferences-in-swiftui/
         https://swiftui-lab.com/view-extensions-for-better-code-readability/
        */
        background(GeometryReader { geo in
            Color.clear.preference(key: SizePrefKey.self,
                                   value: [SizePrefData(viewID: viewID, bounds: geo.frame(in: coordinateSpace))])
        })
    }

    public func retrieveSizes(viewID: Int, completion: @escaping (CGRect) -> Void) -> some View {
        onPreferenceChange(SizePrefKey.self) { preferences in
            DispatchQueue.main.async {
                // The async is used to prevent a possible blocking loop,
                // due to the child and the ancestor modifying each other.
                let p = preferences.first(where: { $0.viewID == viewID })
                completion(p?.bounds ?? .zero)
            }
        }
    }
}
