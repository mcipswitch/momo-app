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
            VStack {
                ZStack {
                    MomoToolbarTitle(viewStore.activeJournal)
                    HStack(alignment: .top) {
                        MomoToolbarButton(.backButton) {
                            viewStore.send(.page(action: .pageChanged(.home)))
                        }

                        Spacer()

                        MomoToolbarButton(viewStore.activeJournal) {
                            viewStore.send(.journal(action: .activeJournalChanged(
                                viewStore.activeJournal == .chart ? .list : .chart)))
                        }
                    }
                }
                .padding()

                ZStack {
                    JournalChartView(store: self.store)
                        .opacity(viewStore.activeJournal == .chart ? 1 : 0)
                    JournalListView(store: self.store)
                        .opacity(viewStore.activeJournal == .list ? 1 : 0)
                }
                
            }
            .addMomoBackground()
        }
    }
}
