//
//  Animations.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-15.
//

import SwiftUI

struct JournalViewAnimation: ViewModifier {
    @Binding var value: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: value ? 0 : 5)
            .opacity(value ? 1 : 0)
    }
}
