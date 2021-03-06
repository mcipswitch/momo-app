//
//  ContentView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
//                if viewStore.activePage == .journal {
//                    MomoJournalView(store: self.store)
//                        .zIndex(2)
//                        .transition(AnyTransition.opacity.animation(.easeInOut))
//                }

                MomoAddMoodView(viewStore: viewStore)
                    .sheet(isPresented: viewStore.binding(
                        keyPath: \.showJournalView,
                        send: AppAction.form
                    )) {
                        MomoJournalView(store: self.store)
                    }

                if viewStore.showSeeYouTomorrowView {
                    MomoSeeYouTomorrowView(viewStore: viewStore)
                        .transition(
                            AnyTransition.opacity
                                .animation(Animation.easeInOut(duration: 0.8))
                        )
                }
            }
        }
    }
}
