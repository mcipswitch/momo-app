//
//  ViewRouter.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-23.
//

import SwiftUI
import Combine

class ViewRouter: ObservableObject {

    let objectWillChange = PassthroughSubject<(), Never>()
    let journalWillChange = PassthroughSubject<(), Never>()
    let textFieldWillChange = PassthroughSubject<String, Never>()

    @Published var currentPage: Page = .home
    @Published var currentJournal: Journal = .graph

    func change(to page: Page) {
        self.objectWillChange.send()
        self.currentPage = page
    }

    func toggleJournal(to journal: Journal) {
        self.journalWillChange.send()
        self.currentJournal = journal
    }

    // MARK: - Helper vars

    var isList: Bool {
        self.currentJournal == .list
    }

    var isGraph: Bool {
        self.currentJournal == .graph
    }

    var isHome: Bool {
        self.currentPage == .home
    }

    var isJournal: Bool {
        self.currentPage == .journal
    }
}

// MARK: - Helpers

enum Page {
    case home, journal
}
