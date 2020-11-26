//
//  ContentView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State var offset: CGFloat = UIScreen.screenWidth
    @State var on = false

    var body: some View {
        ZStack {
            MomoAddMoodView()
            MomoJournalView(selectedEntry: Entry(emotion: "Sunflower", date: Date(), value: 0.68))
                .offset(x: on ? 0 : self.offset)
                .animation(.spring())
        }
        .onReceive(self.viewRouter.objectWillChange) { _ in
            self.on.toggle()
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
