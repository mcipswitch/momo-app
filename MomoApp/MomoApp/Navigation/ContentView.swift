//
//  ContentView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MomoAddMoodView()
//        let env = GlobalEnvironment()
//
//        JournalGraphView(numOfEntries: 7, value: CGFloat(0.5))
//            .background(
//                Image("background")
//                    .edgesIgnoringSafeArea(.all)
//            )
//            .environmentObject(env)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MomoAddMoodView()
    }
}
