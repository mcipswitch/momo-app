//
//  MomoUINavBar.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

extension MomoUI {
    struct NavBarTitle: View {
        let view: JournalType

        init(_ view: JournalType) {
            self.view = view
        }

        var body: some View {
            Text(self.view.title)
                .momoText(.toolbarTitleFont)
        }
    }

    struct NavBarButton: View {
        let icon: Image
        let action: () -> Void

        init(_ icon: Image, action: @escaping () -> Void) {
            self.icon = icon
            self.action = action
        }

        init(_ journal: JournalType, action: @escaping () -> Void) {
            switch journal {
            case .chart:
                self.icon = .momo(.journalList)
            case .list:
                self.icon = .momo(.journalGraph)
            }

            self.action = action
        }

        var body: some View {
            Button(icon: icon, action: action)
                .momoText(.toolbarIconButtonFont)
        }
    }
}

// MARK: - Button+Extension

extension Button where Label == Image {
    init(icon: Image, action: @escaping () -> Void) {
        self.init(action: action) {
            icon
        }
    }
}
