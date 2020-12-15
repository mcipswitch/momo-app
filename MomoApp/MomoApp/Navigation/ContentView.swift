//
//  ContentView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

import SwiftUI

// https://swiftui-lab.com/advanced-transitions/

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var offset: CGFloat = UIScreen.screenWidth
    @State private var journalOn = false
    @State private var blurOn = false

    var body: some View {
        ZStack {
            MomoAddMoodView()

            if journalOn {
                MomoJournalView()
                    .transition(.move(edge: .trailing))
                    .zIndex(2)


//                    .offset(x: self.on ? 0 : self.offset)
//                    .background(
//                        VisualEffectBlur(blurStyle: .dark)
//                            .edgesIgnoringSafeArea(.all)
//                            .opacity(self.blurOn ? 1 : 0)
//                    )
            }

            //Text(journalOn ? "On" : "Off")

        }
        .onReceive(self.viewRouter.objectWillChange) { _ in
            withAnimation(.spring()) {
                self.journalOn.toggle()
            }

            /*
             The background for `MomoJournalView` transitions on with a delay.
             Remove the delay when it transitions on.
             */
//            withAnimation(Animation.spring().delay(self.viewRouter.isHome ? 0.1 : 0)) {
//                self.on.toggle()
//            }

//            withAnimation {
//                self.blurOn.toggle()
//            }
        }
    }

//    private func toggle() {
//        self.on.toggle()
//    }
}

// MARK: - Previews

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(ViewRouter())
            ContentView()
                .previewDevice("iPhone 11 Pro")
                .environmentObject(ViewRouter())
        }
    }
}
#endif
