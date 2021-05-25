//
//  MomoAppApp.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

import SwiftUI
import ComposableArchitecture

@main
struct MomoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(initialState: AppState(entries: self.mockEntries),
                             reducer: appReducer,
                             environment: AppEnvironment()
                )
            )
            .preferredColorScheme(.dark)
        }
    }

    let mockEntries =  [
        Entry(emotion: "Morning", date: Calendar.current.date(byAdding: .day, value: -11, to: Date())!, value: 0.34),
        Entry(emotion: "Sunflower", date: Calendar.current.date(byAdding: .day, value: -10, to: Date())!, value: 0.1),
        Entry(emotion: "Mountains", date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!, value: 0.2),
        Entry(emotion: "Poetry", date: Calendar.current.date(byAdding: .day, value: -8, to: Date())!, value: 0.5),
        Entry(emotion: "Ocean", date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, value: 1.0),
        Entry(emotion: "Fire", date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, value: 0.65),
        Entry(emotion: "Artsy", date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, value: 0.56),
        Entry(emotion: "Gloomy", date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, value: 0.43),
        Entry(emotion: "Candy", date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, value: 0.88),
        Entry(emotion: "Lights", date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, value: 0.47),
        Entry(emotion: "Hummingbird", date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, value: 0.15),
        Entry(id: UUID(), emotion: "Sunflower", date: Date(), value: 0.37)
    ]
}
