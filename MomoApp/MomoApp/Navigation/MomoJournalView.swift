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
                HStack {
                    BackButton(action: self.handleBack)
                    Spacer()
                    ListViewButton(action: self.handleBack)
                }
                .padding(16)
            }
        }
    }
    
    // MARK: - Internal Methods
    
    private func handleBack() {
        print("Back...")
    }
}

struct MomoJournalView_Previews: PreviewProvider {
    static var previews: some View {
        MomoJournalView()
    }
}
