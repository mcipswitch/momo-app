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
                Text(viewStore.selectedEntry.date, formatter: .standard)
                    .momoText(.mainDateFont)
                Text(viewStore.selectedEntry.emotion)
                    .momoText(.mainMessageFont)
            }

            Spacer()

            GeometryReader { geo in
                BlobView(
                    blobValue: self.viewStore.binding(
                        keyPath: \.selectedEntry.value,
                        send: AppAction.form
                    )
                )
                .position(x: geo.w / 2, y: geo.h / 2)
                .momoBlobStyle(
                    BlobStyle(frameSize: geo.w, scale: 0.40)
                )
            }

            Spacer()
        }
    }
}
