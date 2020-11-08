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
                // Navigation Buttons
                ZStack {
                    HStack {
                        BackButton(action: self.handleBack)
                        Spacer()
                        ListViewButton(action: self.handleListView)
                    }
                    GraphViewScaleButton(action: self.handleScaleButton)
                }
                .padding()
                
                // Main View
                VStack(spacing: 48) {
                    JournalGraphView(value: pct)
                    VStack(spacing: 12) {
                        Text(Date(), formatter: DateFormatter.shortDate)
                            .dateText(opacity: 0.6)
                        Text(word)
                            .momoTextBold()
                        BlobView(pct: $pct, frameSize: 250)
                            .scaleEffect(0.60)
                        Spacer()
                    }
                }
                .padding(.top, 48)
            }
        }
        .background(Image("background")
                        .edgesIgnoringSafeArea(.all)
        )
    }
    
    // MARK: - Internal Methods
    
    private func handleBack() {
        print("Back...")
    }
    
    private func handleListView() {
        print("List view...")
    }
    
    private func handleScaleButton() {
        // is there a cleaner way to write this?
        print("Month...")
    }
}

struct MomoJournalView_Previews: PreviewProvider {
    static var previews: some View {
        MomoJournalView()
    }
}
