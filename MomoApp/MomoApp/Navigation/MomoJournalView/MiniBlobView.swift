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

            GeometryReader { geo in
                BlobView(blobValue: $blobValue)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    .msk_applyBlobStyle(BlobStyle(frameSize: geo.size.width,
                                                  scale: 0.40))
            }

            Spacer()
        }
    }
}
