//
//  JournalGraphView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-01.
//

import SwiftUI
import ComposableArchitecture

struct JournalChartView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(spacing: 8) {
                MiniChartView(
                    viewStore: viewStore,
                    entries: viewStore.journalEntries,
                    dataPoints: viewStore.dataPoints
                )
                MiniBlobView(
                    blobValue: viewStore.binding(
                        get: \.selectedEntry.value,
                        send: { .home(action: .blobValueChanged($0)) }
                    ),
                    entry: viewStore.selectedEntry)
            }
        }
    }
}
