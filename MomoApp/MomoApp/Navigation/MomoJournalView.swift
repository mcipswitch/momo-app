//
//  MomoJournalView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI
import ComposableArchitecture

struct MomoJournalView: View {
    let store: Store<AppState, AppAction>
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    @State var animateList = false
    @State var animateGraph = false

    var body: some View {
        VStack {
            navigationToolbar
            ZStack {
                JournalGraphView(viewStore: self.viewStore)
                    .maskEntireView()
                    .journalViewAnimation(value: $animateGraph)
                JournalListView(store: self.store)
                    .journalViewAnimation(value: $animateList)
            }
        }
        .addMomoBackground()
        .onChange(of: self.viewStore.activeJournal) { journal in
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
}

// MARK: - Internal Methods

extension MomoJournalView {
    private func backButtonPressed() {
        self.viewStore.send(.page(action: .pageChanged(.home)))
    }

    private func journalButtonPressed() {
        if self.viewStore.activeJournal == .graph {
            self.viewStore.send(.journal(action: .journalTypeChanged(.list)))
        } else {
            self.viewStore.send(.journal(action: .journalTypeChanged(.graph)))
        }

    }
}

// MARK: - Internal Views

extension MomoJournalView {
    private var navigationToolbar: some View {
        ZStack {
            MomoToolbarTitle(view: self.viewStore.activeJournal)
            HStack(alignment: .top) {
                MomoToolbarButton(.back, action: self.backButtonPressed)

                Spacer()

                MomoToolbarButton(self.viewStore.activeJournal,
                                  action: self.journalButtonPressed)
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
