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
                //.onAppear(perform: self.viewModel.fetchNextPageIfPossible)
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

    @State var animate: Double = 0

    var body: some View {
        ForEach(self.entries.indices, id: \.self) { idx in
            EntryRow(entry: self.entries[idx])
                .onAppear {

                    // Call `onScrolledAtBottom()` when the last entry appears on the screen.
                    if self.entries.last == self.entries[idx] {
                        self.onScrolledAtBottom()
                    }
                }



//                .opacity(animate)
//                .onAnimationCompleted(for: animate, completion: {
//                    // TODO: - Wait for the ENTIRE animation to finish
//                    // Enable toggle journal button on animation completion
//                    self.viewRouter.toggleHitTesting(true)
//                })
//                .animation(.cascade(offset: Double(idx)))
        }
//        .onReceive(self.viewRouter.journalWillChange) {
//
//            // Disable toggle journal button when animating
//            self.viewRouter.toggleHitTesting(false)
//
//            // Add delay so we can see the cascading animation
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                // Cascades ON and OFF
//                self.animate = animate == 1 ? 0 : 1
//            }
//        }

        if self.isLoading {
            loadingIndicator
        }
    }

    private var loadingIndicator: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .momo))
            .scaleEffect(1.5, anchor: .center)
            .padding()
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
                    BlobView(blobValue: $blobValue, isStatic: true, scale: 0.2)
                        .padding(.trailing, 16)
                }
            }
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
            .padding([.leading, .trailing], 24)
            .padding([.top, .bottom], 16)
            .background(VisualEffectBlur(blurStyle: .dark))
            .clipShape(
                RoundedRectangle(cornerRadius: 8, style: .continuous))
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
