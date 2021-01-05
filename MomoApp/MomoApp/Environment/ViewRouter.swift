//
//  ViewRouter.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-23.
//

import SwiftUI
import Combine

// TODO: - Fix objectwillchange binding

class ViewRouter: ObservableObject {
    
    let objectWillChange = PassthroughSubject<(Page), Never>()
    let journalWillChange = PassthroughSubject<(JournalType), Never>()
    let homeWillChange = PassthroughSubject<(HomeState), Never>()

    @Published var currentPage: Page = .home
    @Published var currentJournal: JournalType = .graph
    @Published var currentHomeState: HomeState = .home

    func change(to page: Page) {
        self.objectWillChange.send(page)
        self.currentPage = page
    }

    func toggleJournal() {
        self.journalWillChange.send(currentJournal)
        self.currentJournal = isGraph ? .list : .graph
    }

    func changeHomeState(_ state: HomeState) {
        self.homeWillChange.send(state)
        self.currentHomeState = state
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

    // MARK: - Enums
    
    enum Page {
        case home, journal
    }

    enum HomeState {
        case home, add, done
    }
}
