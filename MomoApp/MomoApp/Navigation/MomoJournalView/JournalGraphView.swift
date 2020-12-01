//
//  JournalGraphView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-01.
//

import SwiftUI

// MARK: - JournalGraphView

struct JournalGraphView: View {
    @Binding var blobValue: CGFloat
    let selectedEntry: Entry

    var body: some View {
        VStack(spacing: 48) {
            MiniGraphView()
            MiniBlobView(blobValue: $blobValue, entry: self.selectedEntry)
        }
    }
}
