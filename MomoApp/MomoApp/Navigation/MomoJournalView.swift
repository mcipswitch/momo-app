//
//  MomoJournalView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

struct MomoJournalView: View {
    @State var pct: CGFloat = 0.5
    @State var word = "Sunflower"
    
    var body: some View {    
        ZStack {
            GeometryReader { geometry in
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                    .edgesIgnoringSafeArea(.all)
                
                // Navigation Buttons
                ZStack {
                    HStack {
                        BackButton(action: self.handleBack)
                        Spacer()
                        ListViewButton(action: self.handleListView)
                    }
                    CalendarMonthButton(action: self.handleMonthSelection)
                }
                .padding()
                
                // Main View
                VStack(spacing: 36) {
                    JournalGraphView(value: pct)
                    VStack(spacing: 12) {
                        Text(Date(), formatter: DateFormatter.shortDate)
                            .dateText(opacity: 0.6)
                            .padding(.top, 16)
                        Text(word)
                            .momoTextBold()
                        BlobView(pct: $pct, frameSize: 250)
                            .scaleEffect(0.60)
                    }
                }
                .padding(.top, 48)
            }
        }
    }
    
    // MARK: - Internal Methods
    
    private func handleBack() {
        print("Back...")
    }
    
    private func handleListView() {
        print("List view...")
    }
    
    private func handleMonthSelection() {
        // is there a cleaner way to write this?
        print("Month...")
    }
}

struct MomoJournalView_Previews: PreviewProvider {
    static var previews: some View {
        MomoJournalView()
    }
}
