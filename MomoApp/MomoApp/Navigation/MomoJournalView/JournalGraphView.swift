//
//  JournalGraphView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-01.
//

import SwiftUI

struct JournalGraphView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var viewModel: EntriesViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            MiniGraphView(
                entries: self.viewModel.latestEntries,
                dataPoints: self.viewModel.dataPoints,
                onEntrySelected: self.viewModel.fetchSelectedEntry(idx:)
            )
            MiniBlobView(
                blobValue: self.$viewModel.selectedEntry.value,
                entry: self.viewModel.selectedEntry)
        }
    }
}
