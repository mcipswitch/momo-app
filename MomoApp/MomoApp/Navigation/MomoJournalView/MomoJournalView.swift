//
//  MomoJournalView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

struct MomoJournalView: View {
    @ObservedObject var viewModel = EntriesViewModel(dataManager: MockDataManager())
    @State var entrySelection: Entry?
    @State var numOfEntries: Int = 7
    @State var isGraphView: Bool = true
    @State var pct: CGFloat = 0.5
    
    var body: some View {    
        ZStack {
            GeometryReader { geometry in

                // Top Navigation
                ZStack {
                    GraphViewScale(isGraphView: $isGraphView)
                    HStack {
                        BackButton(action: self.handleBack)
                        Spacer()
                        if isGraphView {
                            ListViewButton(action: self.handleJournalView)
                        } else {
                            GraphViewButton(action: self.handleJournalView)
                        }
                    }
                }
                .padding()

                // Main View
                VStack(spacing: 48) {
                    if isGraphView {
                        JournalGraphView(numOfEntries: numOfEntries, value: pct)
                        VStack(spacing: 0) {
                            Text(entrySelection?.date ?? Date(), formatter: DateFormatter.shortDate)
                                .dateText(opacity: 0.6)
                                .padding(.bottom, 12)
                            Text(entrySelection?.emotion ?? "")
                                .momoTextBold()
                            BlobView(pct: $pct, isStatic: false)
                                .scaleEffect(0.60)
                            Spacer()
                        }
                    } else {
                        // TODO: Inject with entry
                        JournalListView()
                    }
                }
                .padding(.top, 48)
            }
        }
        .background(RadialGradient.momo
                        .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            self.entrySelection = viewModel.entries.first
        }
    }
    
    // MARK: - Internal Methods
    
    private func handleBack() {
        print("Back...")
    }
    
    private func handleJournalView() {
        print("List view...")
        self.isGraphView.toggle()
    }
}

// MARK: - Previews

struct MomoJournalView_Previews: PreviewProvider {
    static var previews: some View {
        let env = GlobalEnvironment()
        MomoJournalView()
            .environmentObject(env)
    }
}
