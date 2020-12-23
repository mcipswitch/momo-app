//
//  EntryRowStyle.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-23.
//

import SwiftUI

// MARK: - EntryRowStyle

public struct EntryRowStyle {
    let blobScale: CGFloat
    let cornerRadius: CGFloat
    let entryLabelSpacing: CGFloat
    let padding: EdgeInsets

    public init(
        blobScale: CGFloat = 0.2,
        cornerRadius: CGFloat = 8,
        entryLabelSpacing: CGFloat = 8,
        padding: EdgeInsets = EdgeInsets(top: 16,
                                         leading: 24,
                                         bottom: 16,
                                         trailing: 40)
    ) {
        self.blobScale = blobScale
        self.cornerRadius = cornerRadius
        self.entryLabelSpacing = entryLabelSpacing
        self.padding = padding
    }
}

// MARK: - EntryRowStyleEnvironmentKey

struct EntryRowStyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: EntryRowStyle = .init()
}

// MARK: - EnvironmentValues+Extensions

extension EnvironmentValues {
    /// An additional environment value that will hold the line chart style.
    var entryRowStyle: EntryRowStyle {
        get { self[EntryRowStyleEnvironmentKey.self] }
        set { self[EntryRowStyleEnvironmentKey.self] = newValue }
    }
}

// MARK: - View+Extensions

extension View {
    /// An extension on View protocol that allows us to insert chart styles into a view hierarchy environment.
    func msk_applyEntryRowStyle(_ style: EntryRowStyle) -> some View {
        environment(\.entryRowStyle, style)
    }
}
