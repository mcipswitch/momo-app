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
            VStack {
                MiniChartView(
                    store: self.store,
                    viewStore: viewStore
                )

                Spacer()

                MiniBlobView(viewStore: viewStore)
            }
        }
    }
}
