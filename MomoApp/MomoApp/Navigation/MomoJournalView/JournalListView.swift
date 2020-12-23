//
//  JournalListView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

// Blur Effect Materials: https://pspdfkit.com/blog/2020/blur-effect-materials-on-ios/
// Infinite Scroll: https://www.vadimbulavin.com/infinite-list-scroll-swiftui-combine/

import SwiftUI

// MARK: - JournalListView

struct JournalListView: View {
    @Environment(\.journalStyle) var journalStyle
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var viewModel: EntriesViewModel

    var body: some View {
        ScrollView {
            LazyVGrid(columns: journalStyle.listLayout) {
                EntriesList(
                    entries: self.viewModel.entries.reversed()
                )
            }
            .padding()
        }
    }
}

// MARK: - EntriesList

struct EntriesList: View {
    let entries: [Entry]

    var body: some View {
        ForEach(self.entries, id: \.self) { entry in
            EntryRow(entry: entry, blobValue: entry.value)
        }
    }
}

// MARK: - EntryRow

struct EntryRow: View {
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
        .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
        .padding(entryRowStyle.padding)
        .background(
            VisualEffectBlur(blurStyle: .dark)
        )
        .roundedRect(entryRowStyle.cornerRadius)
    }
}

// MARK: - Internal Views

extension EntryRow {
    private var entryDateAndEmotion: some View {
        VStack(alignment: .leading, spacing: entryRowStyle.entryLabelSpacing) {
            Text(self.entry.date, formatter: DateFormatter.shortDate)
                .msk_applyTextStyle(.mainDateFont)
            Text(self.entry.emotion)
                .msk_applyTextStyle(.mainMessageFont)
        }
    }

    private var blobView: some View {
        BlobView(blobValue: self.$blobValue)
            .msk_applyBlobStyle(BlobStyle(scale: entryRowStyle.blobScale,
                                          isStatic: true))
    }
}
