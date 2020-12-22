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
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Text(self.entry.date, formatter: DateFormatter.shortDate)
                    .msk_applyTextStyle(.mainDateFont)
                Text(self.entry.emotion)
                    .msk_applyTextStyle(.mainMessageFont)
            }

            Spacer()

            // TODO: - Fix the frameSize to be dynamic
            BlobView(blobValue: $blobValue)
                .msk_applyBlobStyle(BlobStyle(frameSize: 250,
                                              scale: 0.60))

            Spacer()
        }
    }
}
