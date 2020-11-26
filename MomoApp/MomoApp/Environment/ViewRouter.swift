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
    let animate = PassthroughSubject<(), Never>()

    @Published var currentPage: Page = .home

    func change(to page: Page) {
        objectWillChange.send()
        self.currentPage = self.isHome ? .journal : .home

        // Add delay to trigger line graph animation after the view has transitioned on
        DispatchQueue.main.asyncAfter(deadline: .now() + (self.isHome ? 0 : 0.8)) {
            self.animate.send()
        }
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
