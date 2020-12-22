//
//  SizeModifier.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-05.
//

import SwiftUI

// MARK: - Save + Retrieve Bounds

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
         Please see: https://swiftwithmajid.com/2020/01/15/the-magic-of-view-preferences-in-swiftui/
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

// MARK: - Save + Retrieve Bounds

// Please see: https://swiftui-lab.com/view-extensions-for-better-code-readability/

struct SaveBoundsPrefData: Equatable {
    let viewID: Int
    let bounds: CGRect
}

struct SaveBoundsPrefKey: PreferenceKey {
    static var defaultValue: [SaveBoundsPrefData] = []
    static func reduce(value: inout [SaveBoundsPrefData], nextValue: () -> [SaveBoundsPrefData]) {
        value.append(contentsOf: nextValue())
    }
}

extension View {
    public func saveBounds(viewID: Int, coordinateSpace: CoordinateSpace = .global) -> some View {
        /**
         Attach a geometry reader to a view as a background to read its size.
         Please see: https://swiftwithmajid.com/2020/01/15/the-magic-of-view-preferences-in-swiftui/
        */
        background(GeometryReader { geo in
            Color.clear.preference(key: SaveBoundsPrefKey.self,
                                   value: [SaveBoundsPrefData(viewID: viewID, bounds: geo.frame(in: coordinateSpace))])
        })
    }

    public func retrieveBounds(viewID: Int, _ rect: Binding<CGRect>) -> some View {
        onPreferenceChange(SaveBoundsPrefKey.self) { preferences in
            DispatchQueue.main.async {
                // The async is used to prevent a possible blocking loop,
                // due to the child and the ancestor modifying each other.
                let p = preferences.first(where: { $0.viewID == viewID })
                rect.wrappedValue = p?.bounds ?? .zero
            }
        }
    }
}

// MARK: - Deprecated

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

// MARK: - View+Extension

extension View {
    func attachSizeModifier() -> some View {
        return self.modifier(SizeModifier())
    }
}
