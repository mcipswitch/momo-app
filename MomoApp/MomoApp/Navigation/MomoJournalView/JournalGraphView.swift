//
//  JournalGraphView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-01.
//

import SwiftUI
import ComposableArchitecture

struct JournalGraphView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    
    var body: some View {
        VStack(spacing: 8) {
            MiniGraphView(
                viewStore: self.viewStore,
                entries: self.viewStore.journalEntries,
                dataPoints: self.viewStore.dataPoints
            )
            MiniBlobView(
                blobValue: self.viewStore.binding(
                    get: \.selectedEntry.value,
                    send: { .home(action: .blobValueChanged($0)) }
                ),
                entry: self.viewStore.selectedEntry)
        }
    }
}
