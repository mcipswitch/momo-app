//
//  MomoJournalView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI
import ComposableArchitecture

struct MomoJournalView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>



    @EnvironmentObject var viewRouter: ViewRouter
    @State var currentJournal: ToolbarButton = .list
    @State var animateList = false
    @State var animateGraph = false

    var body: some View {
        VStack {
            navigationToolbar
            ZStack {
                JournalGraphView(viewStore: self.viewStore)
                    .maskEntireView()
                    .journalViewAnimation(value: $animateGraph)
                JournalListView(viewStore: self.viewStore)
                    .journalViewAnimation(value: $animateList)
            }
        }
        .addMomoBackground()
        .onReceive(self.viewRouter.journalWillChange) { journal in
            withAnimation(Animation.ease.delay(if: !animateGraph, 0.5)) {
                self.animateGraph.toggle()
            }
            withAnimation(Animation.ease.delay(if: !animateList, 0.5)) {
                self.animateList.toggle()
            }

            var isGraph: Bool { journal == .graph }

            self.currentJournal = isGraph ? .graph : .list
        }
        .onAppear {
            self.animateGraph.toggle()
        }
    }
}

// MARK: - Internal Methods

extension MomoJournalView {
    private func backButtonPressed() {
        viewStore.send(.page(action: .pageChanged(.home)))

        self.viewRouter.changePage(to: .home)
    }

    private func journalButtonPressed() {
        if self.viewRouter.isGraph {
            self.viewRouter.toggleJournal(to: .list)
        } else {
            self.viewRouter.toggleJournal(to: .graph)
        }
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
                MomoToolbarButton(self.currentJournal, action: self.journalButtonPressed)
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
