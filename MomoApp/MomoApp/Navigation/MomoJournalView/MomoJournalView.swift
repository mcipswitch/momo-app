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
                    JournalViewTypeTitle(view: self.isGraphActive ? .graph : .list)
                        .slideIn(if: $isGraphActive)
                    HStack {
                        BackButton(action: self.backButtonPressed)
                        Spacer()
                        JournalViewTypeButton(view: self.isGraphActive ? .graph : .list, action: self.journalTypeButtonPressed)
                    }
                }.padding()

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
        .onChange(of: self.isGraphActive) { value in
            // Add delay so we can see the cascading animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.animateList.toggle()

                // disable the graph view change for 0.8 seconds to let the full animation to avoid bug
            }
        }
    }
    
    // MARK: - Internal Methods

    var didChangeJournalView: (() -> Void)? = nil
    
    private func backButtonPressed() {
        print("Back...")
    }
    
    private func journalTypeButtonPressed() {
        print("List view...")
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
                .dateText(opacity: 0.6)
                .padding(.bottom, 12)
            Text(self.entry.emotion)
                .momoTextBold()
            BlobView(blobValue: $blobValue, isStatic: false)
                .scaleEffect(0.60)
            Spacer()
        }
    }
}

struct JournalViewTypeTitle: View {
    var view: JournalViewType
    var body: some View {
        Text(view.title).calendarMonthText()
    }
}

// MARK: - Previews

struct MomoJournalView_Previews: PreviewProvider {
    static var previews: some View {
        let env = GlobalEnvironment()
        MomoJournalView(selectedEntry: Entry(emotion: "Sunflower", date: Date(), value: 0.68))
            .environmentObject(env)
    }
}
