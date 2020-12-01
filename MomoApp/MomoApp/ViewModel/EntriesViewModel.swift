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
    @Published private(set) var state = InfiniteScrollState()
    @Published var entries = [Entry]()
    @Published var selectedEntry: Entry = Entry(emotion: "Sunflower", date: Date(), value: 0.9)
    @Published var dataPoints = [CGFloat]()

    /// Default number of entries in `JournalGraphView`
    var numOfEntries: Int = 7
    
    var dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager.shared) {
        self.dataManager = dataManager
        self.fetchEntries(page: state.page)
        self.fetchDataPoints()
    }

    func fetchNextPageIfPossible() {
        guard state.canLoadNextPage else { return }

        // Add delay to simulate async behaviour
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fetchEntries(page: self.state.page)
        }
    }
}

// MARK: - EntriesViewModelProtocol

extension EntriesViewModel: EntriesViewModelProtocol {
    func fetchEntries(page: Int) {

        // TODO: - fix this ugly shit!!!!!!!

        var idx: (start: Int, end: Int?)

        if page == 1 {
            idx = (0, state.pageSize * page)
        }
        else if state.pageSize * page > dataManager.fetchEntries().count {
            idx = (state.pageSize * page - state.pageSize, nil)
        }
        else {
            idx = (state.pageSize * page - state.pageSize, state.pageSize * page)
        }


        let fetchedEntries: ArraySlice<Entry>

        if let end = idx.end {
            fetchedEntries = dataManager.fetchEntries()[idx.start ..< end]
        } else {
            fetchedEntries = dataManager.fetchEntries()[idx.start...]
        }

        self.entries.append(contentsOf: fetchedEntries)
        self.state.page += 1


        self.state.canLoadNextPage = fetchedEntries.count == 10
    }

    func fetchDataPoints() {
        self.entries.suffix(7).forEach{ self.dataPoints.append($0.value) }
    }
}

// MARK: - Protocol

protocol EntriesViewModelProtocol {
    var entries: [Entry] { get }
    func fetchEntries(page: Int)
    func fetchDataPoints()
}

// MARK: - Model

struct Entry: Identifiable, Hashable {
    var id = UUID()
    var emotion: String
    var date: Date
    var value: CGFloat
}

// MARK: - State

struct InfiniteScrollState {
    var pageSize: Int = 10
    var page: Int = 1
    var canLoadNextPage = true
}
