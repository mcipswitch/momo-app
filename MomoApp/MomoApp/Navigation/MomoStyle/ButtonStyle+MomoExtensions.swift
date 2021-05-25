//
//  ButtonStyle+MomoExtensions.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2021-05-24.
//

import SwiftUI

struct MomoButtonStyle: ButtonStyle {
    typealias SizeTuple = (w: CGFloat, h: CGFloat)

    var text: String
    var size: SizeTuple
    var icon: Image?
}

extension MomoButtonStyle {
    static var mainStandard: Self {
        return .init(text: String(),
                     size: SizeTuple(w: 230, h: 60),
                     icon: nil)
    }

    static var mainJoystick: Self {
        return .init(text: String(),
                     size: SizeTuple(w: 80, h: 80),
                     icon: nil)
    }

    static var done: Self {
        return .init(text: "Done".localized,
                     size: SizeTuple(w: 90, h: 34),
                     icon: Image.momo(.arrowRight))
    }
}

extension MomoButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(button: self, configuration: configuration)
    }

    struct Button: View {
        let button: MomoButtonStyle
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool

        private var w: CGFloat { button.size.w }
        private var h: CGFloat { button.size.h }
        private var cornerRadius: CGFloat { return button.size.h / 2 }

        var body: some View {
            configuration.label
                .momoText(.standardButtonFont)
                .foregroundColor(.momo)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .frame(width: self.w, height: self.h)
                .background(Color.momo)
                .cornerRadius(self.cornerRadius)
                .opacity(self.isEnabled ? 1 : 0.2)
        }
    }
}
// MARK: - View+Extension

extension View {
    func momoButtonStyle(button: MomoButtonStyle) -> some View {
        self.buttonStyle(button)
    }
}

