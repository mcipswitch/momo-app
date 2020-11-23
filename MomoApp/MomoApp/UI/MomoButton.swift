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
        .momoButtonStyle(w: 90, h: 34, isActive: isActive)
        .disabled(!isActive)
        .animation(.ease())
    }
}

struct MomoButtonStyle: ButtonStyle {
    var w: CGFloat
    var h: CGFloat
    var isActive: Bool = true
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .momoTextRegular(textStyle: .button)
            .frame(width: w, height: h)
            .background(Color.momo)
            .cornerRadius(h / 2)
            .opacity(isActive ? 1 : 0.2)
    }
}

extension View {
    func momoButtonStyle(w: CGFloat, h: CGFloat, isActive: Bool = true) -> some View {
        return self.buttonStyle(MomoButtonStyle(w: w, h: h, isActive: isActive))
    }
}

// MARK: - Previews

struct NextButton_Previews: PreviewProvider {
    static var previews: some View {
        MomoButton(isActive: .constant(true), type: .next, action: {})
    }
}
