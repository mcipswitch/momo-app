//
//  ListViewButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

enum JournalViewType {
    case list, graph

    var image: Image {
        switch self {
        case .list: return Image(systemName: "list.bullet")
        case .graph: return Image(systemName: "chart.bar.xaxis")
        }
    }

    var title: String {
        switch self {
        case .list: return "All entries"
        case .graph: return "Last 7 days"
        }
    }
}

struct JournalViewTypeButton: View {
    var view: JournalViewType
    var action: (() -> Void)?

    var body: some View {
        Button(action: action ?? {} ) {
            view.image
        }.momoTextRegular()
    }
}

// MARK: - Previews

struct JournalViewTypeButton_Previews: PreviewProvider {
    static var previews: some View {
        JournalViewTypeButton(view: .list)
    }
}
