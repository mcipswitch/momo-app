//
//  JournalListView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

// https://www.vadimbulavin.com/infinite-list-scroll-swiftui-combine/

import SwiftUI

// MARK: - JournalListView

struct JournalListView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var viewModel = EntriesViewModel(dataManager: MockDataManager())

    var layout: [GridItem] { [GridItem(.flexible())] }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout) {
                EntriesList(
                    entries: self.viewModel.entries,
                    isLoading: self.viewModel.state.canLoadNextPage,
                    onScrolledAtBottom: self.viewModel.fetchNextPageIfPossible
                )
            }
            .padding()
        }
    }
}

// MARK: - EntriesList

struct EntriesList: View {
    let entries: [Entry]
    let isLoading: Bool
    let onScrolledAtBottom: () -> Void

    var body: some View {
        ForEach(self.entries.indices, id: \.self) { idx in
            EntryRow(entry: self.entries[idx])
                .onAppear {
                    if self.entries.last == self.entries[idx] {
                        self.onScrolledAtBottom()
                    }
                }
        }

        if self.isLoading {
            MomoLoadingIndicator()
        }
    }
}

// MARK: - EntryRow

struct EntryRow: View {
    private let entry: Entry
    @State var blobValue: CGFloat = 0

    init(entry: Entry) {
        self.entry = entry
    }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(entry.date, formatter: DateFormatter.shortDate)
                            .momoText(.date)
                        Text(entry.emotion)
                            .momoText(.main)
                    }
                    Spacer()
                    BlobView(
                        blobValue: $blobValue,
                        isStatic: true,
                        scale: 0.2
                    )
                    .padding(.trailing, 16)
                }
            }
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(VisualEffectBlur(blurStyle: .dark))
            .clipShape(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
            )
        }
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
