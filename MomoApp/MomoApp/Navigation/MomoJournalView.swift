//
//  MomoJournalView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

struct MomoJournalView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var viewModel = EntriesViewModel(dataManager: MockDataManager())
    @State var selectedEntry: Entry
    @State var blobValue: CGFloat = 0.5
    @State var animateList: Bool = false
    @State var animateGraph = true
    @State var isGraphActive: Bool = true


    /// The journal button on the toolbar.
    var journalButton: ToolbarButtonType {
        self.isGraphActive ? .graph : .list
    }
    
    var body: some View {
        VStack {
            // TODO: - fix toolbar animation
            ZStack {
                MomoToolbarTitle(type: self.journalButton)
                HStack(alignment: .top) {
                    MomoToolbarButton(type: .back, action: self.backButtonPressed)
                    Spacer()
                    MomoToolbarButton(type: self.journalButton, action: self.journalTypeButtonPressed)
                }
            }
            .padding()

            // Main View
            ZStack {
                VStack(spacing: 48) {
                    JournalGraphView(value: blobValue)
                    MiniBlobView(blobValue: $blobValue, entry: selectedEntry)
                }

                // TODO: - Fix so the graph animates back on, add delay
                .offset(y: animateGraph ? 0 : 5)
                .opacity(animateGraph ? 1 : 0)
                .onReceive(self.viewRouter.journalWillChange) {
                    self.animateGraph.toggle()
                }
                //.simpleSlideOut(if: $isGraphActive)

                JournalListView()
                    .simpleSlideIn(if: $isGraphActive)
            }
        }
        // Add a delay when `MomoJournalView` transitions on from right
        .animation(Animation.spring().delay(self.viewRouter.isHome ? 0 : 0.1))
        .background(RadialGradient.momo.edgesIgnoringSafeArea(.all))
    }
    
    // MARK: - Internal Methods

    private func backButtonPressed() {
        self.viewRouter.change(to: .home)
    }
    
    private func journalTypeButtonPressed() {
        self.isGraphActive.toggle()
        self.viewRouter.toggleJournal()
    }
}

// MARK: - Views

struct MiniBlobView: View {
    @Binding var blobValue: CGFloat
    let entry: Entry

    var body: some View {
        VStack(spacing: 0) {
            Text(self.entry.date, formatter: DateFormatter.shortDate)
                .momoText(.date)
                .padding(.bottom, 12)
            Text(self.entry.emotion)
                .momoText(.main)
            BlobView(blobValue: $blobValue, isStatic: false)
                .scaleEffect(0.60)
            Spacer()
        }
    }
}


// MARK: - Previews

#if DEBUG
struct MomoJournalView_Previews: PreviewProvider {
    static var previews: some View {
        MomoJournalView(selectedEntry: Entry(emotion: "Sunflower", date: Date(), value: 0.68))
            .environmentObject(ViewRouter())
    }
}
#endif
