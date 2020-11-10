//
//  MomoJournalView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

struct MomoJournalView: View {
    @State var isGraphView: Bool = true
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
                        if isGraphView {
                            ListViewButton(action: self.handleJournalView)
                        } else {
                            GraphViewButton(action: self.handleJournalView)
                        }
                    }
                    GraphViewScaleButton(isGraphView: $isGraphView, action: self.handleScaleButton)
                }
                .padding()
                
                // Main View
                VStack(spacing: 48) {
                    if isGraphView {
                        JournalGraphView(value: pct)
                        VStack(spacing: 12) {
                            Text(Date(), formatter: DateFormatter.shortDate)
                                .dateText(opacity: 0.6)
                            Text(word)
                                .momoTextBold()
                            BlobView(pct: $pct, isStatic: false)
                                .scaleEffect(0.60)
                            Spacer()
                        }
                    } else {
                        JournalListView()
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
    
    private func handleJournalView() {
        print("List view...")
        self.isGraphView.toggle()
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
