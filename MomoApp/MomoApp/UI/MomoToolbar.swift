//
//  MomoToolbarTitle.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

// MARK: - MomoToolbarTitle

struct MomoToolbarTitle: View {
    let view: JournalType
    
    var body: some View {
        Text(view.title)
            .msk_applyTextStyle(.toolbarTitleFont)
    }
}

// MARK: - MomoToolbarButton

struct MomoToolbarButton: View {
    let button: ToolbarButton
    let action: () -> Void

    init(_ icon: ToolbarButton, action: @escaping () -> Void) {
        self.button = icon
        self.action = action
    }

    var body: some View {
        Button(icon: button, action: action)
            .msk_applyTextStyle(.toolbarIconButtonFont)
    }
}

// MARK: - Button+Extension

extension Button where Label == Image {
    init(icon: ToolbarButton, action: @escaping () -> Void) {
        self.init(action: action, label: {
            Image(systemName: icon.imageName)
        })
    }
}
