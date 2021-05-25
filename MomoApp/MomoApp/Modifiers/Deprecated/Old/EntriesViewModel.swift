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

//final class EntriesViewModel: ObservableObject {
//    @Published var entries: [Entry] = []
//    @Published var selectedEntry: Entry = Entry(emotion: "Random", date: Date(), value: 1.0)
//
//    /// Set the default number of entries to show in `JournalGraphView`
//    private var numOfEntries: Int = 7
//
//    /// Latest entries shown in `JournalGraphView`
//    var latestEntries: [Entry] {
//        self.entries.suffix(self.numOfEntries)
//    }
//
//    /// Data points for `MiniGraphView`
//    var dataPoints: [CGFloat] {
//        self.entries.suffix(8).map(\.value)
//    }
//
//    var dataManager: DataManagerProtocol
//
//    init(dataManager: DataManagerProtocol = DataManager.shared) {
//        self.dataManager = dataManager
//        self.fetchEntries()
//    }
//}
//
//// MARK: - EntriesViewModelProtocol
//
//extension EntriesViewModel: EntriesViewModelProtocol {
//
//    func fetchSelectedEntry(idx: Int) {
//        self.selectedEntry = self.latestEntries[idx]
//    }
//
//    func fetchEntries() {
//        self.entries = dataManager.fetchEntries()
//    }
//}
//
//// MARK: - EntriesViewModelProtocol
//
//protocol EntriesViewModelProtocol {
//    var entries: [Entry] { get }
//    func fetchEntries()
//    func fetchSelectedEntry(idx: Int)
//}
