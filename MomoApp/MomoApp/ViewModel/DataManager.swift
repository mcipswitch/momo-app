//
//  DataManager.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

import Foundation

class DataManager {
    static let shared: DataManagerProtocol = DataManager()
    private var entries: [Entry] = []
    private init() {}
}

// MARK: - DataManagerProtocol

extension DataManager: DataManagerProtocol {
    func fetchEntries() -> [Entry] {
        entries
    }
    
    func add(entry: Entry) {
        entries.insert(entry, at: 0)
    }
}

// MARK: - Protocol

protocol DataManagerProtocol {
    func fetchEntries() -> [Entry]
    func add(entry: Entry)
}
