//
//  EntriesViewModel.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//
//  Inspired by: https://medium.com/swlh/getting-started-with-swiftui-and-combine-using-mvvm-and-protocols-for-ios-d8c37731a1d9

import Combine
import Foundation
import SwiftUI

final class EntriesViewModel: ObservableObject {
    @Published private(set) var state = State()
    @Published var entries = [Entry]()
    @Published var selectedIdx = Int()

    /// Default number of entries shown in `JournalGraphView`
    var numOfEntries: Int = 7

    /// Latest entries shown in `JournalGraphView`
    var latestEntries: [Entry] {
        self.entries.suffix(self.numOfEntries)
    }

    var selectedEntry: Entry {
        self.latestEntries[self.selectedIdx]
    }

    /// Data points for `MiniGraphView`
    var dataPoints = [CGFloat]()
    
    var dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager.shared) {
        self.dataManager = dataManager
        self.fetchEntries()
        self.fetchDataPoints()
    }

    struct State {
        var page: Int = 1
        var canLoadNextPage = true
        var isLoading = false
    }
}

// MARK: - EntriesViewModelProtocol

extension EntriesViewModel: EntriesViewModelProtocol {



    func changeSelectedIdx(to idx: Int) {
        self.selectedIdx = idx
    }

    func fetchEntries() {
        self.entries = dataManager.fetchEntries()
    }

    func fetchDataPoints() {
        self.latestEntries.forEach{ self.dataPoints.append($0.value) }
    }
}

// MARK: - Protocol

protocol EntriesViewModelProtocol {
    var entries: [Entry] { get }
    func fetchEntries()
    func fetchDataPoints()
    func changeSelectedIdx(to idx: Int)
}

// MARK: - Model

struct Entry: Identifiable, Hashable {
    var id = UUID()
    var emotion: String
    var date: Date
    var value: CGFloat
}
