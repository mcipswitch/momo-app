//
//  JournalGraphView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-01.
//

import SwiftUI

// MARK: - JournalGraphView

struct JournalGraphView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var viewModel = EntriesViewModel(dataManager: MockDataManager())

    @Binding var blobValue: CGFloat
    let selectedEntry: Entry

    var body: some View {
        VStack(spacing: 48) {
            MiniGraphView(
                entries: self.viewModel.latestEntries,
                numOfEntries: self.viewModel.numOfEntries,
                dataPoints: self.viewModel.dataPoints)
            MiniBlobView(blobValue: $blobValue, entry: self.selectedEntry)
        }
    }
}
