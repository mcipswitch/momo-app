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
    let lineWillAnimate = PassthroughSubject<(), Never>()

    @Published var currentPage: Page = .home
    @Published var currentJournal: Journal = .graph

    func change(to page: Page) {
        objectWillChange.send()
        self.currentPage = self.isHome ? .journal : .home

        // Add delay to trigger line graph animation after the view has transitioned on
        DispatchQueue.main.asyncAfter(deadline: .now() + (self.isHome ? 0 : 1.0)) {
            self.lineWillAnimate.send()
        }
    }

    func toggleJournal() {
        self.currentJournal = self.isGraph ? .list : .graph
        self.journalWillChange.send()
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
