//
//  JournalMiniBlobView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-01.
//

import SwiftUI

// MARK: - JournalMiniBlobView

struct JournalMiniBlobView: View {
    @Binding var blobValue: CGFloat
    let entry: Entry

    var body: some View {
        VStack(spacing: 0) {
            Text(self.entry.date, formatter: DateFormatter.shortDate)
                .momoText(.date)
                .padding(.bottom, 12)
            Text(self.entry.emotion)
                .momoText(.main)
            BlobView(blobValue: $blobValue, isStatic: false)
                .scaleEffect(0.60)
            Spacer()
        }
    }
}
