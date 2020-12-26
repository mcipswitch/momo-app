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

    var body: some View {
        VStack {
            navigationToolbar
            ZStack {
                JournalGraphView()
                    .journalViewAnimation(value: $animateGraph)
                JournalListView()
                    .journalViewAnimation(value: $animateList)
            }
        }
        .addMomoBackground()
        .onReceive(self.viewRouter.journalWillChange) {
            withAnimation(Animation.ease.delay(if: !animateGraph, 0.5)) {
                self.animateGraph.toggle()
            }
            withAnimation(Animation.ease.delay(if: !animateList, 0.5)) {
                self.animateList.toggle()
            }
        }
        .onAppear {
            self.animateGraph.toggle()
        }
    }

    // MARK: - Helper vars

    private var currentJournal: ToolbarButton {
        self.isGraph ? .list : .graph
    }
}

// MARK: - Internal Methods

extension MomoJournalView {
    private func backButtonPressed() {
        self.viewRouter.change(to: .home)
    }

    private func journalTypeButtonPressed() {
        self.isGraph.toggle()
        self.viewRouter.toggleJournal()
    }
}

// MARK: - Internal Views

extension MomoJournalView {
    private var navigationToolbar: some View {
        ZStack {
            MomoToolbarTitle(view: self.viewRouter.currentJournal)
            HStack(alignment: .top) {
                MomoToolbarButton(.back, action: self.backButtonPressed)
                Spacer()
                MomoToolbarButton(self.currentJournal, action: self.journalTypeButtonPressed)
            }
        }
        .padding()
    }
}

// MARK: - Animations

struct JournalViewAnimation: ViewModifier {
    @Binding var value: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: value ? 0 : 5)
            .opacity(value ? 1 : 0)
    }
}

// MARK: - View+Extension

extension View {
    func journalViewAnimation(value: Binding<Bool>) -> some View {
        return modifier(JournalViewAnimation(value: value))
    }
}

// MARK: - Previews

#if DEBUG
struct MomoJournalView_Previews: PreviewProvider {
    static var previews: some View {
        MomoJournalView()
            .environmentObject(ViewRouter())
            .environmentObject(EntriesViewModel(dataManager: MockDataManager()))
    }
}
#endif
