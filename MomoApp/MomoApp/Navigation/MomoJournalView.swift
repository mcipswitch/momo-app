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
    @State var numOfEntries: Int = 7
    @State var blobValue: CGFloat = 0.5
    @State var animateList: Bool = false
    @State var animateGraph: Bool = false
    @State var isGraphActive: Bool = true




    /// The journal button on the toolbar.
    var journalButton: ToolbarButtonType {
        self.isGraphActive ? .graph : .list
    }
    
    var body: some View {
        VStack {
            // Toolbar
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
                    JournalGraphView(numOfEntries: numOfEntries, value: blobValue, animateGraph: $animateGraph)
                    MiniBlobView(blobValue: $blobValue, entry: selectedEntry)
                }
                .simpleSlideOut(if: $isGraphActive)

                JournalListView(animate: $animateList)
                    .simpleSlideIn(if: $isGraphActive)
            }
        }
        // Add a delay when `MomoJournalView` transitions on
        .animation(Animation.spring().delay(self.viewRouter.isHome ? 0 : 0.1))




        .background(RadialGradient.momo.edgesIgnoringSafeArea(.all))
        .onChange(of: self.isGraphActive) { graph in
            if graph == false {
                // Add delay so we can see the cascading animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.animateList.toggle()
                }
            } else if graph == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.animateGraph.toggle()
                }
            }
        }
    }
    
    // MARK: - Internal Methods

    var didFinishAnimation: (() -> Void)? = nil
    
    private func backButtonPressed() {
        self.viewRouter.currentPage = .home
    }
    
    private func journalTypeButtonPressed() {
        // TODO: - // Add delay if we are switching from list to graph
        self.isGraphActive.toggle()
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
