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
    @State var isGraphActive = true

    @State var animateList = false
    @State var animateGraph = false

    /// The journal button on the toolbar.
    var journalButton: ToolbarButtonType {
        self.isGraphActive ? .graph : .list
    }
    
    var body: some View {
        VStack {
            // TODO: - Fix toolbar animation, right icon is migrating right
            ZStack {
                MomoToolbarTitle(type: self.journalButton)
                HStack(alignment: .top) {
                    MomoToolbarButton(type: .back, action: self.backButtonPressed)
                    Spacer()
                    MomoToolbarButton(type: self.journalButton, action: self.journalTypeButtonPressed)
                }
            }
            .padding()

            ZStack {
                VStack(spacing: 48) {
                    JournalGraphView(value: blobValue)
                    MiniBlobView(blobValue: $blobValue, entry: selectedEntry)
                }
                .offset(y: animateGraph ? 0 : 5)
                .opacity(animateGraph ? 1 : 0)
                .onReceive(self.viewRouter.journalWillChange) {
                    withAnimation(Animation.ease().delay(if: !animateGraph, 0.5)) {
                        self.animateGraph.toggle()
                    }
                }
                JournalListView()
                    .offset(y: animateList ? 0 : 5)
                    .opacity(animateList ? 1 : 0)
                    .onReceive(self.viewRouter.journalWillChange) {
                        withAnimation(.ease()) {
                            withAnimation(Animation.ease().delay(if: !animateList, 0.5)) {
                                self.animateList.toggle()
                            }
                        }
                    }
            }
        }
        /*
         Animation must be added BEFORE the background.
         The main content for `MomoJournalView` transitions on with a delay.
         Remove the delay when it transitions off.
         */
        //.animation(Animation.spring().delay(self.viewRouter.isHome ? 0 : 0.1))
        .background(RadialGradient.momo.edgesIgnoringSafeArea(.all))
        .onAppear {
            self.animateGraph = true
        }
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
