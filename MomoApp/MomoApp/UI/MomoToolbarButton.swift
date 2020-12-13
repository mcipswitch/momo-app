//
//  ToolbarButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

// MARK: - MomoToolbarTitle

struct MomoToolbarTitle: View {
    let view: Momo.Journal.View
    
    var body: some View {
        Text(view.title)
            .momoText(.appToolbarTitle)
    }
}

// MARK: - MomoToolbarButton

struct MomoToolbarButton: View {
    let button: Momo.ToolbarButton
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: button.imageName)
        }
        .momoText(.appToolbarButton)
    }
}
