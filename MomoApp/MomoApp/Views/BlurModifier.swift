//
//  BlurModifier.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-09.
//

import SwiftUI

// MARK: - BlurModifier

struct BlurModifier: ViewModifier {

    @Binding var showOverlay: Bool
    @State private var blurRadius: CGFloat = 10

    func body(content: Content) -> some View {
        Group {
            content
                .blur(radius: self.showOverlay ? blurRadius : 0)
                .animation(.easeInOut)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Extension

extension View {
    func blurModifier(showOverlay: Binding<Bool>) -> some View {
        return self.modifier(BlurModifier(showOverlay: showOverlay))
    }
}
