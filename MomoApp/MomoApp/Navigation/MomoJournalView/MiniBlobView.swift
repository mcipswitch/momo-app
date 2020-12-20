//
//  JournalMiniBlobView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-01.
//

import SwiftUI

struct MiniBlobView: View {
    @Binding var blobValue: CGFloat
    let entry: Entry

    var body: some View {
        VStack(spacing: 0) {
            Text(self.entry.date, formatter: DateFormatter.shortDate)
                .msk_applyTextStyle(.mainDateFont)
                .padding(.bottom, 12)
            Text(self.entry.emotion)
                .msk_applyTextStyle(.mainMessageFont)
            BlobView(blobValue: $blobValue)
                .scaleEffect(0.60)
            Spacer()
        }
    }
}
