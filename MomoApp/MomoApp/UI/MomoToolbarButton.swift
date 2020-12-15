//
//  ToolbarButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

// MARK: - MomoToolbarTitle

struct MomoToolbarTitle: View {
    let view: MSK.Journal.View
    
    var body: some View {
        Text(view.title)
            .msk_applyStyle(.toolbarTitleFont)
    }
}

// MARK: - MomoToolbarButton

struct MomoToolbarButton: View {
    let button: MSK.ToolbarButton
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: button.imageName)
        }
        .msk_applyStyle(.toolbarIconButtonFont)
    }
}
