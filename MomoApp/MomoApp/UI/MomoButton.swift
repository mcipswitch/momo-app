//
//  NextButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

enum MomoButtonType {
    case next
    var imageName: String {
        switch self {
        case .next:
            return "arrow.right"
        }
    }
}

struct MomoButton: View {
    @Binding var isActive: Bool
    var type: MomoButtonType
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text("Next")
                Image(systemName: type.imageName)
            }
        }
        .buttonStyle(MomoButtonStyle(w: 90, h: 34, isActive: isActive))
        .disabled(!isActive)
        .animation(.ease())
    }
}

// MARK: - Previews

struct NextButton_Previews: PreviewProvider {
    static var previews: some View {
        MomoButton(isActive: .constant(true), type: .next, action: {})
    }
}
