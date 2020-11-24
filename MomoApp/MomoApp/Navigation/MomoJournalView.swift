//
//  MomoJournalView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

struct MomoJournalView: View {
    @ObservedObject var viewModel = EntriesViewModel(dataManager: MockDataManager())
    @State var selectedEntry: Entry
    @State var numOfEntries: Int = 7
    @State var isGraphActive: Bool = true
    @State var blobValue: CGFloat = 0.5
    @State var animateList: Bool = false
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    MomoToolbarTitle(type: self.isGraphActive ? .graph : .list)
                    HStack {
                        MomoToolbarButton(type: .back, action: self.backButtonPressed)
                        Spacer()
                        MomoToolbarButton(type: self.isGraphActive ? .graph : .list, action: self.journalTypeButtonPressed)
                    }
                }
                .padding()

                ZStack {
                    VStack(spacing: 48) {
                        JournalGraphView(numOfEntries: numOfEntries, value: blobValue)
                        MiniBlobView(entry: $selectedEntry, blobValue: $blobValue)
                    }
                    .slideOut(if: $isGraphActive)

                    JournalListView(animate: $animateList)
                        .slideIn(if: $isGraphActive)
                }.padding(.top, 48)
            }
        }
        .background(RadialGradient.momo.edgesIgnoringSafeArea(.all))
        .onAppear {
            self.selectedEntry = viewModel.entries.first ?? Entry(emotion: "Sunflower", date: Date(), value: 0.68)
        }
        .onChange(of: self.isGraphActive) { graph in
            if graph == false {
                // Add delay so we can see the cascading animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.animateList.toggle()
                }
            } else {
                self.animateList.toggle()
            }
        }
    }
    
    // MARK: - Internal Methods

    var didFinishAnimation: (() -> Void)? = nil
    
    private func backButtonPressed() {
        print("Back...")
    }
    
    private func journalTypeButtonPressed() {
        self.isGraphActive.toggle()
    }
}

// MARK: - Views

struct MiniBlobView: View {
    @Binding var entry: Entry
    @Binding var blobValue: CGFloat

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
        let env = GlobalEnvironment()
        MomoJournalView(selectedEntry: Entry(emotion: "Sunflower", date: Date(), value: 0.68))
            .environmentObject(env)
    }
}
#endif
