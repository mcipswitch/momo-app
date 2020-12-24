//
//  MiniBlobView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-01.
//

import SwiftUI

// MARK: - MiniBlobView

struct MiniBlobView: View {
    @Binding var blobValue: CGFloat
    let entry: Entry

    var body: some View {
        VStack(spacing: 16) {
            entryDateAndEmotion

            Spacer()

            GeometryReader { geo in
                blobView
                    .position(x: geo.w / 2, y: geo.h / 2)
                    .msk_applyBlobStyle(
                        BlobStyle(frameSize: geo.w,
                                  scale: 0.40)
                    )
            }

            Spacer()
        }
    }
}

// MARK: - Internal Views

extension MiniBlobView {
    private var entryDateAndEmotion: some View {
        VStack(spacing: 12) {
            Text(self.entry.date, formatter: .shortDate)
                .msk_applyTextStyle(.mainDateFont)
            Text(self.entry.emotion)
                .msk_applyTextStyle(.mainMessageFont)
        }
    }

    private var blobView: some View {
        BlobView(blobValue: $blobValue)
    }
}
