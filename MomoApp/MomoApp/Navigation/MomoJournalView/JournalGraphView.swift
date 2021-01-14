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
    @EnvironmentObject var viewModel: EntriesViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            MiniGraphView(
                viewStore: self.viewStore,
                entries: self.viewStore.journalEntries,
                dataPoints: self.viewStore.dataPoints
            )
            MiniBlobView(
                blobValue: self.$viewModel.selectedEntry.value,
                entry: self.viewModel.selectedEntry)
        }
    }
}
