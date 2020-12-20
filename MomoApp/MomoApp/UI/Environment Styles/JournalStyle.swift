//
//  JournalStyle.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-20.
//

import SwiftUI

public struct JournalStyle {
    let listLayout: [GridItem]

    public init(
        listLayout: [GridItem] = [GridItem(.flexible())]
    ) {
        self.listLayout = listLayout
    }
}

// MARK: - LineChartStyleEnvironmentKey

struct JournalStyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: JournalStyle = .init()
}

// MARK: - EnvironmentValues+Extensions

extension EnvironmentValues {
    /// An additional environment value that will hold the line chart style.
    var journalStyle: JournalStyle {
        get { self[JournalStyleEnvironmentKey.self] }
        set { self[JournalStyleEnvironmentKey.self] = newValue }
    }
}

// MARK: - View+Extensions

// NOT USED
extension View {
    /// An extension on View protocol that allows us to insert chart styles into a view hierarchy environment.
    func msk_applyLineChartStyle(_ style: JournalStyle) -> some View {
        environment(\.journalStyle, style)
    }
}
