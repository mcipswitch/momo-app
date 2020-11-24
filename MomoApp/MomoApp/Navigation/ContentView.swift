//
//  ContentView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        ZStack {
            switch self.viewRouter.currentPage {
            case .home:
                MomoAddMoodView()
            case .journal:
                MomoJournalView(selectedEntry: Entry(emotion: "Sunflower", date: Date(), value: 0.68))
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewRouter())
    }
}
#endif
