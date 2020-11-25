//
//  ViewRouter.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-23.
//

import SwiftUI

class ViewRouter: ObservableObject {

    @Published var currentPage: Page = .home

    var isHome: Bool {
        self.currentPage == .home
    }

}

// MARK: - Helpers

enum Page {
    case home, journal
}
