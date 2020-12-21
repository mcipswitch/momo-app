//
//  MomoJournalView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

// MARK: - MomoJournalView

struct MomoJournalView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State var isGraph = true
    @State var animateList = false
    @State var animateGraph = false

    /// The journal button on the toolbar.
    var journal: ToolbarButton {
        self.isGraph ? .list : .graph
    }

    var body: some View {
        VStack {
            navigationToolbar
            ZStack {
                JournalGraphView()
                    .msk_applyJournalViewAnimation(value: $animateGraph)
                JournalListView()
                    .msk_applyJournalViewAnimation(value: $animateList)
            }
        }
        .onReceive(self.viewRouter.journalWillChange) {
            withAnimation(Animation.ease.delay(if: !animateGraph, 0.5)) {
                self.animateGraph.toggle()
            }
            withAnimation(Animation.ease.delay(if: !animateList, 0.5)) {
                self.animateList.toggle()
            }
        }


        /*
         Animation must be added BEFORE the background.
         The main content for `MomoJournalView` transitions on with a delay.
         Remove the delay when it transitions off.
         */
        //.animation(Animation.spring().delay(self.viewRouter.isHome ? 0 : 0.1))


        .msk_applyMomoBackground()

        .onAppear {
            self.animateGraph.toggle()
        }
    }

    private var navigationToolbar: some View {
        ZStack {
            MomoToolbarTitle(view: self.viewRouter.currentJournal)
            HStack(alignment: .top) {
                MomoToolbarButton(button: .back, action: self.backButtonPressed)
                Spacer()
                MomoToolbarButton(button: self.journal, action: self.journalTypeButtonPressed)
            }
        }
        .padding()
    }
    
    // MARK: - Internal Methods

    private func backButtonPressed() {
        self.viewRouter.change(to: .home)
    }
    
    private func journalTypeButtonPressed() {
        self.isGraph.toggle()
        self.viewRouter.toggleJournal()
    }
}

// MARK: - Previews

#if DEBUG
struct MomoJournalView_Previews: PreviewProvider {
    static var previews: some View {
        MomoJournalView()
            .environmentObject(ViewRouter())
    }
}
#endif
