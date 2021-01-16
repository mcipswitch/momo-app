//
//  JournalListView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

import SwiftUI
import ComposableArchitecture

struct JournalListView: View {
    let store: Store<AppState, AppAction>
    @Environment(\.journalStyle) var journalStyle

    var body: some View {
        ScrollView {
            LazyVGrid(columns: self.journalStyle.listLayout) {
                WithViewStore(self.store) { viewStore in
                    ForEachStore(
                        self.store.scope(
                            state: \.reversedEntries,
                            action: AppAction.entry(index:action:)
                        ), content: EntryRow.init(store:)
                    )
                }
            }
            .padding()
        }
    }
}

// MARK: - EntryRow

struct EntryRow: View {
    let store: Store<Entry, EntryAction>
    @Environment(\.entryRowStyle) var entryRowStyle

    init(store: Store<Entry, EntryAction>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                HStack {
                    VStack(alignment: .leading, spacing: self.entryRowStyle.entryLabelSpacing) {
                        Text(viewStore.date, formatter: .shortDate)
                            .msk_applyTextStyle(.mainDateFont)
                        Text(viewStore.emotion)
                            .msk_applyTextStyle(.mainMessageFont)
                    }

                    Spacer()

                    BlobView(blobValue: viewStore.binding(
                                get: \.value,
                                send: EntryAction.emotionValueChanged)
                    )
                    .msk_applyBlobStyle(
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
            .padding(self.entryRowStyle.padding)
            .background(VisualEffectBlur(blurStyle: .dark))
            .roundedRect(self.entryRowStyle.cornerRadius)
        }
    }
}
