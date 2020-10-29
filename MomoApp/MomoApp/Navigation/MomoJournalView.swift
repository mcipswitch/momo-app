//
//  MomoJournalView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

struct MomoJournalView: View {
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
                        ListViewButton(action: self.handleBack)
                    }
                    CalendarMonthButton(action: self.handleMonthSelection)
                }
                .padding(16)
                
                VStack(spacing: 48) {
                    JournalGraphView()
                }
            }
        }
    }
    
    // MARK: - Internal Methods
    
    private func handleBack() {
        print("Back...")
    }
    
    private func handleMonthSelection() {
        print("Month...")
    }
}

struct MomoJournalView_Previews: PreviewProvider {
    static var previews: some View {
        MomoJournalView()
    }
}
