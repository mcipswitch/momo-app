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
            Entry(id: UUID(), emotion: "Sunflower", date: date.createDate(year: 2020, month: 06, day: 08), value: 0.6),
            Entry(id: UUID(), emotion: "Mountains", date: date.createDate(year: 2020, month: 01, day: 04), value: 0.9),
            Entry(id: UUID(), emotion: "Poetry", date: date.createDate(year: 2020, month: 07, day: 28), value: 0.7),
            Entry(id: UUID(), emotion: "Ocean", date: date.createDate(year: 2020, month: 11, day: 08), value: 0.3),
            Entry(id: UUID(), emotion: "Fire", date: date.createDate(year: 2020, month: 08, day: 11), value: 0.3),
            Entry(id: UUID(), emotion: "Artsy", date: date.createDate(year: 2020, month: 08, day: 09), value: 0.3),
            Entry(id: UUID(), emotion: "Gloomy", date: date.createDate(year: 2020, month: 08, day: 08), value: 0.3),
            Entry(id: UUID(), emotion: "Candy", date: date.createDate(year: 2020, month: 08, day: 07), value: 0.3),
            Entry(id: UUID(), emotion: "Lights", date: date.createDate(year: 2020, month: 08, day: 06), value: 0.3)
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
