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
    @State var isGraphViewActive: Bool = true
    @State var blobValue: CGFloat = 0.5
    
    var body: some View {    
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    LastSevenDays()
                        .slideOut(if: $isGraphViewActive)
                    AllEntries()
                        .slideIn(if: $isGraphViewActive)
                    HStack {
                        BackButton(action: self.backButtonPressed)
                        Spacer()
                        if self.isGraphViewActive {
                            ListViewButton(action: self.journalTypeButtonPressed)
                        } else {
                            GraphViewButton(action: self.journalTypeButtonPressed)
                        }
                    }
                }.padding()

                ZStack {
                    VStack(spacing: 48) {
                        JournalGraphView(numOfEntries: numOfEntries, value: blobValue)
                        MiniBlobView(entry: $selectedEntry, blobValue: $blobValue)
                    }
                    .slideOut(if: $isGraphViewActive)

                    JournalListView()
                        .slideIn(if: $isGraphViewActive)
                }.padding(.top, 48)
            }
        }
        .background(RadialGradient.momo
                        .edgesIgnoringSafeArea(.all))
        .onAppear {
            self.selectedEntry = viewModel.entries.first ?? Entry(emotion: "Sunflower", date: Date(), value: 0.68)
        }
    }
    
    // MARK: - Internal Methods
    
    private func backButtonPressed() {
        print("Back...")
    }
    
    private func journalTypeButtonPressed() {
        print("List view...")
        self.isGraphViewActive.toggle()
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

struct LastSevenDays: View {
    var body: some View {
        Text("Last 7 days").calendarMonthText()
    }
}

struct AllEntries: View {
    var body: some View {
        Text("All entries").calendarMonthText()
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
