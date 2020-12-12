//
//  ToolbarButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

enum Journal {
    case list, graph
}

// MARK: - MomoToolbarTitle

struct MomoToolbarTitle: View {
    let button: Momo.ToolbarButton
    
    var body: some View {
        Text(button.title)
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
