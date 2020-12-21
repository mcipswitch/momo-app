//
//  ContentView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var offset: CGFloat = UIScreen.screenWidth
    @State private var journalOn = false
    @State private var blurOn = false

    var body: some View {
        ZStack {

            // IMPORTANT: - `MomoJournalView` must be underneath to avoid zIndex crash
            if journalOn {
                MomoJournalView()
                    .transition(.move(edge: .trailing))
                    .zIndex(2)
            }
            MomoAddMoodView()
                .msk_applyBackgroundBlurStyle(.systemMaterialDark, value: blurOn)
        }
        .onReceive(viewRouter.objectWillChange, perform: showJournalView)
    }

    private func showJournalView() {
        withAnimation(.spring()) {
            blurOn = viewRouter.isJournal
            journalOn = viewRouter.isJournal
        }
    }
}

// MARK: - Previews

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 8")
                .environmentObject(ViewRouter())
            ContentView()
                .previewDevice("iPhone 11 Pro")
                .environmentObject(ViewRouter())
        }
    }
}
#endif
