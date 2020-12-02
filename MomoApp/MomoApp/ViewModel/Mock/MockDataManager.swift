//
//  MockDataManager.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

import SwiftUI

class MockDataManager {
    private var entries = [Entry]()
    
    private let date = Date()
    
    init() {
        entries = [
            Entry(id: UUID(), emotion: "Random", date: date.createDate(year: 2020, month: 06, day: 01), value: 0.14),
            Entry(id: UUID(), emotion: "Tree", date: date.createDate(year: 2020, month: 06, day: 02), value: 0.73),
            Entry(id: UUID(), emotion: "Nostalgic", date: date.createDate(year: 2020, month: 06, day: 03), value: 0.58),
            Entry(id: UUID(), emotion: "Blue", date: date.createDate(year: 2020, month: 06, day: 04), value: 0.52),
            Entry(id: UUID(), emotion: "Jazz", date: date.createDate(year: 2020, month: 06, day: 05), value: 0.69),
            Entry(id: UUID(), emotion: "Building", date: date.createDate(year: 2020, month: 06, day: 06), value: 0.69),
            Entry(id: UUID(), emotion: "Maniac", date: date.createDate(year: 2020, month: 06, day: 07), value: 0.56),
            Entry(id: UUID(), emotion: "Music", date: date.createDate(year: 2020, month: 06, day: 08), value: 0.95),
            Entry(id: UUID(), emotion: "Dance", date: date.createDate(year: 2020, month: 06, day: 09), value: 0.29),
            Entry(id: UUID(), emotion: "Laughter", date: date.createDate(year: 2020, month: 06, day: 10), value: 0.95),
            Entry(id: UUID(), emotion: "Memory", date: date.createDate(year: 2020, month: 06, day: 11), value: 0.92),
            Entry(id: UUID(), emotion: "River", date: date.createDate(year: 2020, month: 06, day: 12), value: 0.59),
            Entry(id: UUID(), emotion: "Cooking", date: date.createDate(year: 2020, month: 06, day: 13), value: 0.83),
            Entry(id: UUID(), emotion: "Chill", date: date.createDate(year: 2020, month: 06, day: 14), value: 0.33),
            Entry(id: UUID(), emotion: "Writing", date: date.createDate(year: 2020, month: 06, day: 15), value: 0.62),
            Entry(id: UUID(), emotion: "Gray", date: date.createDate(year: 2020, month: 06, day: 16), value: 0.07),
            Entry(id: UUID(), emotion: "Travel", date: date.createDate(year: 2020, month: 06, day: 17), value: 0.73),
            Entry(id: UUID(), emotion: "Plane", date: date.createDate(year: 2020, month: 06, day: 18), value: 0.97),
            Entry(id: UUID(), emotion: "Shadows", date: date.createDate(year: 2020, month: 06, day: 19), value: 0.93),
            Entry(id: UUID(), emotion: "Night", date: date.createDate(year: 2020, month: 06, day: 20), value: 0.19),
            Entry(id: UUID(), emotion: "Sunrise", date: date.createDate(year: 2020, month: 06, day: 21), value: 0.94),
            Entry(id: UUID(), emotion: "Movie", date: date.createDate(year: 2020, month: 06, day: 22), value: 0.68),
            Entry(id: UUID(), emotion: "Light", date: date.createDate(year: 2020, month: 06, day: 23), value: 0.53),
            Entry(id: UUID(), emotion: "Listen", date: date.createDate(year: 2020, month: 06, day: 24), value: 0.73),
            Entry(id: UUID(), emotion: "Grief", date: date.createDate(year: 2020, month: 06, day: 25), value: 0.96),
            Entry(id: UUID(), emotion: "Smile", date: date.createDate(year: 2020, month: 06, day: 26), value: 0.68),
            Entry(id: UUID(), emotion: "Morning", date: date.createDate(year: 2020, month: 06, day: 27), value: 0.42),
            Entry(id: UUID(), emotion: "Sunflower", date: date.createDate(year: 2020, month: 06, day: 28), value: 0.92),
            Entry(id: UUID(), emotion: "Mountains", date: date.createDate(year: 2020, month: 11, day: 07), value: 0.42),
            Entry(id: UUID(), emotion: "Poetry", date: date.createDate(year: 2020, month: 11, day: 08), value: 0.18),
            Entry(id: UUID(), emotion: "Ocean", date: date.createDate(year: 2020, month: 11, day: 09), value: 0.23),
            Entry(id: UUID(), emotion: "Fire", date: date.createDate(year: 2020, month: 11, day: 10), value: 0.3),
            Entry(id: UUID(), emotion: "Artsy", date: date.createDate(year: 2020, month: 11, day: 11), value: 0.72),
            Entry(id: UUID(), emotion: "Gloomy", date: date.createDate(year: 2020, month: 11, day: 12), value: 0.56),
            Entry(id: UUID(), emotion: "Candy", date: date.createDate(year: 2020, month: 11, day: 13), value: 0.78),
            Entry(id: UUID(), emotion: "Lights", date: date.createDate(year: 2020, month: 11, day: 14), value: 0.20),
            Entry(id: UUID(), emotion: "Today", date: date, value: 0.5)
        ]
    }
}

// MARK: - DataManagerProtocol

extension MockDataManager: DataManagerProtocol {
    func fetchEntries() -> [Entry] {
        return entries.sorted{$0.date < $1.date}
    }

    func add(entry: Entry) {
        entries.insert(entry, at: 0)
    }
}
