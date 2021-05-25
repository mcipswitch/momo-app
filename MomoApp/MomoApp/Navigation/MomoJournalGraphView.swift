//
//  MomoJournalGraphView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-01.
//

import SwiftUI
import ComposableArchitecture

struct MomoJournalGraphView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(spacing: 40) {
                MiniChartView(viewStore: viewStore)
                MiniBlobView(viewStore: viewStore)
            }
        }
    }
}
