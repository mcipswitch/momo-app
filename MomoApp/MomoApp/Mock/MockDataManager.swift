//
//  MockDataManager.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

import Foundation

class MockDataManager {
    private var entries: [Entry] = []
    
    init() {
        entries = [
            Entry(id: UUID(), emotion: "Sunflower", date: Date(), value: 0.6),
            Entry(id: UUID(), emotion: "Mountains", date: Date(), value: 0.9),
            Entry(id: UUID(), emotion: "Poetry", date: Date(), value: 0.7),
            Entry(id: UUID(), emotion: "Ocean", date: Date(), value: 0.3)
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
