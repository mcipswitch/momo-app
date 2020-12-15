//
//  JournalListView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

// Blur Effect Materials: https://pspdfkit.com/blog/2020/blur-effect-materials-on-ios/
// https://www.vadimbulavin.com/infinite-list-scroll-swiftui-combine/

import SwiftUI

// MARK: - JournalListView

struct JournalListView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var viewModel = EntriesViewModel(dataManager: MockDataManager())

    var body: some View {
        ScrollView {
            LazyVGrid(columns: MSK.Journal.listLayout) {
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
    private let entry: Entry
    @State var blobValue: CGFloat

    init(entry: Entry, blobValue: CGFloat) {
        self.entry = entry
        self._blobValue = State(wrappedValue: blobValue)
    }

    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(self.entry.date, formatter: DateFormatter.shortDate)
                        .msk_applyStyle(.mainDateFont)
                    Text(self.entry.emotion)
                        .msk_applyStyle(.mainMessageFont)
                }
                Spacer()
                BlobView(
                    blobValue: self.$blobValue,
                    isStatic: true,
                    scale: 0.2
                )
                .padding(.trailing, 16)
            }
        }
        .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)


        .padding(.horizontal, 24)
        .padding(.vertical, 16)

        .background(
            VisualEffectBlur(blurStyle: .dark)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
        )
    }
}

// MARK: - Previews

struct JournalListView_Previews: PreviewProvider {
    static var previews: some View {
        var view = JournalListView()
        view.viewModel = EntriesViewModel(dataManager: MockDataManager())
        return view
            .background(
                Image("background")
                    .edgesIgnoringSafeArea(.all)
            )
    }
}
