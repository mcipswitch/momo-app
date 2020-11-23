//
//  BackButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

enum ToolbarButton {
    case back

    var imageName: String {
        switch self {
        case .back:
            return "chevron.backward"
        }
    }
}

struct ToolbarButton: View {
    var button: ToolbarButton
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: button.imageName)
        }
        .momoTextRegular()
    }
}
