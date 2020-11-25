//
//  MockDataManager.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

import Foundation

class MockDataManager {
    private var entries: [Entry] = []
    
    private let date = Date()
    
    init() {
        entries = [
            Entry(id: UUID(), emotion: "Sunflower", date: date.createDate(year: 2020, month: 1, day: 06), value: 0.92),
            Entry(id: UUID(), emotion: "Mountains", date: date.createDate(year: 2020, month: 11, day: 07), value: 0.42),
            Entry(id: UUID(), emotion: "Poetry", date: date.createDate(year: 2020, month: 11, day: 08), value: 0.18),
            Entry(id: UUID(), emotion: "Ocean", date: date.createDate(year: 2020, month: 11, day: 09), value: 0.23),
            Entry(id: UUID(), emotion: "Fire", date: date.createDate(year: 2020, month: 11, day: 10), value: 0.3),
            Entry(id: UUID(), emotion: "Artsy", date: date.createDate(year: 2020, month: 11, day: 11), value: 0.72),
            Entry(id: UUID(), emotion: "Gloomy", date: date.createDate(year: 2020, month: 11, day: 12), value: 0.56),
            Entry(id: UUID(), emotion: "Candy", date: date.createDate(year: 2020, month: 11, day: 13), value: 0.78),
            Entry(id: UUID(), emotion: "Lights", date: date.createDate(year: 2020, month: 11, day: 14), value: 0.45),
            Entry(id: UUID(), emotion: "Today", date: date, value: 0.5)
        ]
    }
}

// MARK: - DataManagerProtocol

extension MockDataManager: DataManagerProtocol {
    func fetchEntries() -> [Entry] {
        entries
    }

    func add(entry: Entry) {
        entries.insert(entry, at: 0)
    }
}
