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
            // This enables the dark mode keyboard.
            .preferredColorScheme(.dark)
        }
    }

    let mockEntries =  [
        Entry(id: UUID(), emotion: "First", date: Date().createDate(year: 2020, month: 06, day: 01), value: 0.12),
        Entry(id: UUID(), emotion: "Tree", date: Date().createDate(year: 2020, month: 06, day: 02), value: 0.73),
        Entry(id: UUID(), emotion: "Nostalgic", date: Date().createDate(year: 2020, month: 06, day: 03), value: 0.58),
        Entry(id: UUID(), emotion: "Blue", date: Date().createDate(year: 2020, month: 06, day: 04), value: 0.52),
        Entry(id: UUID(), emotion: "Jazz", date: Date().createDate(year: 2020, month: 06, day: 05), value: 0.69),
        Entry(id: UUID(), emotion: "Building", date: Date().createDate(year: 2020, month: 06, day: 06), value: 0.69),
        Entry(id: UUID(), emotion: "Maniac", date: Date().createDate(year: 2020, month: 06, day: 07), value: 0.56),
        Entry(id: UUID(), emotion: "Music", date: Date().createDate(year: 2020, month: 06, day: 08), value: 0.95),
        Entry(id: UUID(), emotion: "Dance", date: Date().createDate(year: 2020, month: 06, day: 09), value: 0.29),
        Entry(id: UUID(), emotion: "Laughter", date: Date().createDate(year: 2020, month: 06, day: 10), value: 0.95),
        Entry(id: UUID(), emotion: "Memory", date: Date().createDate(year: 2020, month: 06, day: 11), value: 0.92),
        Entry(id: UUID(), emotion: "River", date: Date().createDate(year: 2020, month: 06, day: 12), value: 0.23),
        Entry(id: UUID(), emotion: "Cooking", date: Date().createDate(year: 2020, month: 06, day: 13), value: 0.45),
        Entry(id: UUID(), emotion: "Chill", date: Date().createDate(year: 2020, month: 06, day: 14), value: 0.33),
        Entry(id: UUID(), emotion: "Writing", date: Date().createDate(year: 2020, month: 06, day: 15), value: 0.62),
        Entry(id: UUID(), emotion: "Gray", date: Date().createDate(year: 2020, month: 06, day: 16), value: 0.07),
        Entry(id: UUID(), emotion: "Travel", date: Date().createDate(year: 2020, month: 06, day: 17), value: 0.25),
        Entry(id: UUID(), emotion: "Plane", date: Date().createDate(year: 2020, month: 06, day: 18), value: 0.02),
        Entry(id: UUID(), emotion: "Shadows", date: Date().createDate(year: 2020, month: 06, day: 19), value: 0.15),
        Entry(id: UUID(), emotion: "Night", date: Date().createDate(year: 2020, month: 06, day: 20), value: 0.22),
        Entry(id: UUID(), emotion: "Sunrise", date: Date().createDate(year: 2020, month: 06, day: 21), value: 0.33),
        Entry(id: UUID(), emotion: "Movie", date: Date().createDate(year: 2020, month: 06, day: 22), value: 0.42),
        Entry(id: UUID(), emotion: "Light", date: Date().createDate(year: 2020, month: 06, day: 23), value: 0.51),
        Entry(id: UUID(), emotion: "Listen", date: Date().createDate(year: 2020, month: 06, day: 24), value: 0.63),
        Entry(id: UUID(), emotion: "Grief", date: Date().createDate(year: 2020, month: 06, day: 25), value: 0.74),
        Entry(id: UUID(), emotion: "Smile", date: Date().createDate(year: 2020, month: 06, day: 26), value: 0.68),
        Entry(id: UUID(), emotion: "Morning", date: Date().createDate(year: 2020, month: 06, day: 27), value: 0.01),
        Entry(id: UUID(), emotion: "Sunflower", date: Date().createDate(year: 2020, month: 06, day: 28), value: 0.1),
        Entry(id: UUID(), emotion: "Mountains", date: Date().createDate(year: 2020, month: 11, day: 07), value: 0.2),
        Entry(id: UUID(), emotion: "Poetry", date: Date().createDate(year: 2020, month: 11, day: 08), value: 0.5),
        Entry(id: UUID(), emotion: "Ocean", date: Date().createDate(year: 2020, month: 11, day: 09), value: 1.0),
        Entry(id: UUID(), emotion: "Fire", date: Date().createDate(year: 2020, month: 11, day: 10), value: 0.65),
        Entry(id: UUID(), emotion: "Artsy", date: Date().createDate(year: 2020, month: 11, day: 11), value: 0.56),
        Entry(id: UUID(), emotion: "Gloomy", date: Date().createDate(year: 2020, month: 11, day: 12), value: 0.43),
        Entry(id: UUID(), emotion: "Candy", date: Date().createDate(year: 2020, month: 11, day: 13), value: 0.98),
        Entry(id: UUID(), emotion: "Lights", date: Date().createDate(year: 2020, month: 11, day: 14), value: 0.56),
        Entry(id: UUID(), emotion: "Today", date: Date(), value: 0.0)
    ]
}
