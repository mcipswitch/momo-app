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
    @State var blurOn = false

    var body: some View {
        ZStack {
            MomoAddMoodView()
                .overlay(
                    VisualEffectBlur(blurStyle: .dark).edgesIgnoringSafeArea(.all)
                        .opacity(self.blurOn ? 1 : 0)
                )
            MomoJournalView()
                .offset(x: self.on ? 0 : self.offset)
        }
        .onReceive(self.viewRouter.objectWillChange) { _ in
            /*
             The background for `MomoJournalView` transitions on with a delay.
             Remove the delay when it transitions on.
             */
            withAnimation(Animation.spring().delay(self.viewRouter.isHome ? 0.1 : 0)) {
                self.on.toggle()
            }

            withAnimation {
                self.blurOn.toggle()
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
