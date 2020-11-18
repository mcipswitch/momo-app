//
//  ListViewButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

enum JournalViewType {
    case list, chart

    var image: Image {
        switch self {
        case .list:
            return Image(systemName: "list.bullet")
        case .chart:
            return Image(systemName: "chart.bar.xaxis")
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

struct JournalViewTypeButton_Previews: PreviewProvider {
    static var previews: some View {
        JournalViewTypeButton(view: .list)
    }
}
