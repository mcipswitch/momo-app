//
//  JournalListView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

// Blur Effect Materials: https://pspdfkit.com/blog/2020/blur-effect-materials-on-ios/
// Infinite Scroll: https://www.vadimbulavin.com/infinite-list-scroll-swiftui-combine/

import SwiftUI
import ComposableArchitecture

struct JournalListView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    @Environment(\.journalStyle) var journalStyle

    var body: some View {
        ScrollView {
            LazyVGrid(columns: self.journalStyle.listLayout) {
                EntriesList(entries: self.viewStore.entries.reversed())
            }
            .padding()
        }
    }
}

// MARK: - EntriesList

struct EntriesList: View {
    let entries: [Entry]

    var body: some View {
        ForEach(self.entries) { entry in
            EntryRow(entry: entry, blobValue: entry.value)
        }
    }
}

// MARK: - EntryRow

struct EntryRow: View {
    //let store: Store<Entry, EntryAction>

    @Environment(\.entryRowStyle) var entryRowStyle
    private let entry: Entry
    @State var blobValue: CGFloat

    init(entry: Entry, blobValue: CGFloat) {
        self.entry = entry
        self._blobValue = State(wrappedValue: blobValue)
    }

    var body: some View {
        ZStack {
            HStack {
                entryDateAndEmotion
                Spacer()
                blobView
            }
        }
        .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
        .padding(self.entryRowStyle.padding)
        .background(VisualEffectBlur(blurStyle: .dark))
        .roundedRect(self.entryRowStyle.cornerRadius)
    }
}

// MARK: - Internal Views

extension EntryRow {
    private var entryDateAndEmotion: some View {
        VStack(alignment: .leading, spacing: self.entryRowStyle.entryLabelSpacing) {
            Text(self.entry.date, formatter: .shortDate)
                .msk_applyTextStyle(.mainDateFont)
            Text(self.entry.emotion)
                .msk_applyTextStyle(.mainMessageFont)
        }
    }

    private var blobView: some View {
        BlobView(blobValue: self.$blobValue)
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
