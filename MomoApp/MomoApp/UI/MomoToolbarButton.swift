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

enum ToolbarButtonType {
    case back, list, graph

    var imageName: String {
        switch self {
        case .back: return "chevron.backward"
        case .list: return "list.bullet"
        case .graph: return "chart.bar.xaxis"
        }
    }

    var title: String {
        switch self {
        case .list: return "All entries"
        case .graph: return "Last 7 days"
        default: return ""
        }
    }
}

struct MomoToolbarTitle: View {
    var type: ToolbarButtonType
    var body: some View {
        Text(type.title)
            .momoText(.appToolbarTitle)
    }
}

struct MomoToolbarButton: View {
    var type: ToolbarButtonType
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: type.imageName)
        }
        .momoText(.appToolbarButton)
    }
}
