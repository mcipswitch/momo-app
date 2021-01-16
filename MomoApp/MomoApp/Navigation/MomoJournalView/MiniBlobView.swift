//
//  MiniBlobView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-01.
//

import SwiftUI
import ComposableArchitecture

struct MiniBlobView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>

    var body: some View {
        VStack {
            VStack(spacing: 12) {
                Text(viewStore.selectedEntry.date, formatter: .shortDate)
                    .msk_applyTextStyle(.mainDateFont)
                Text(viewStore.selectedEntry.emotion)
                    .msk_applyTextStyle(.mainMessageFont)
            }

            Spacer()

            GeometryReader { geo in
                BlobView(blobValue: viewStore.binding(
                    get: \.selectedEntry.value,
                    send: { .home(action: .blobValueChanged($0)) }
                ))
                .position(x: geo.w / 2, y: geo.h / 2)
                .msk_applyBlobStyle(
                    BlobStyle(frameSize: geo.w, scale: 0.40)
                )
            }

            Spacer()
        }
    }
}
