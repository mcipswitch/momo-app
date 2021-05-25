//
//  MainButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

extension MomoUI {
    struct MainButton: View {
        let style: MomoButtonStyle
        let action: () -> Void

        var body: some View {
            Button(action: self.action) {
                HStack {
                    Text(self.style.text)
                    self.style.icon
                }
            }
            .momoButtonStyle(button: self.style)
        }
    }
}
