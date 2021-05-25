//
//  MomoJournalListView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

import SwiftUI
import ComposableArchitecture

struct MomoJournalListView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible())]) {
                WithViewStore(self.store) { viewStore in
                    ForEachStore(
                        self.store.scope(
                            state: { $0.entries.reversed() },
                            action: AppAction.entry(index:action:)
                        ),
                        content: EntryRow.init(store:)
                    )
                }
            }
            .padding()
        }
    }
}

// MARK: - EntryRow

extension MomoJournalListView {
    struct EntryRow: View {
        let store: Store<Entry, EntryAction>

        init(store: Store<Entry, EntryAction>) {
            self.store = store
        }

        var body: some View {
            WithViewStore(self.store) { viewStore in
                ZStack {
                    HStack {
                        VStack(alignment: .leading, spacing: .momo(.scale2)) {
                            Text(viewStore.date, formatter: .standard)
                                .momoText(.mainDateFont)
                            Text(viewStore.emotion)
                                .momoText(.mainMessageFont)
                        }

                        Spacer()

                        BlobView(
                            blobValue: viewStore.binding(
                                get: \.value,
                                send: EntryAction.emotionValueChanged
                            )
                        )
                        .momoBlobStyle(
                            BlobStyle(scale: 0.2,
                                      isStatic: true,
                                      innerTopLeftShadowSpread: 1.0,
                                      innerTopLeftShadowRadius: 10,
                                      innerBottomRightShadowSpread: 1.0,
                                      innerBottomRightShadowRadius: 10)
                        )
                    }
                }
                .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
                .padding(EdgeInsets(top: 16,
                                    leading: 24,
                                    bottom: 16,
                                    trailing: 40))
                .background(VisualEffectBlur(blurStyle: .dark))
                .roundedRect(.momo(.scale2))
            }
        }
    }
}
