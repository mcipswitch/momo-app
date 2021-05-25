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

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(spacing: 0) {
                NavBar(store: self.store)
                    .padding()

                ZStack {
                    MomoJournalGraphView(store: self.store)
                        .opacity(viewStore.activeJournal == .chart ? 1 : 0)
                    MomoJournalListView(store: self.store)
                        .opacity(viewStore.activeJournal == .list ? 1 : 0)
                }
            }
            .momoBackground()
        }
    }

    struct NavBar: View {
        let store: Store<AppState, AppAction>

        var body: some View {
            WithViewStore(self.store) { viewStore in
                ZStack {
                    MomoUI.NavBarTitle(viewStore.activeJournal)
                    HStack(alignment: .center) {
                        MomoUI.NavBarButton(.momo(.close)) {
                            viewStore.send(.form(.set(\.showJournalView, false)))
                        }
                        Spacer()
                        MomoUI.NavBarButton(viewStore.activeJournal) {
                            viewStore.send(.toggleActiveJournal)
                        }
                    }
                }
            }
        }
    }
}
