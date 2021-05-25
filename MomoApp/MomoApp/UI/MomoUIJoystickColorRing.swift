//
//  ColorRing.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-24.
//

// https://nerdyak.tech/development/2019/09/30/animating-gradients-swiftui.html

import SwiftUI

// MARK: - MomoUIJoystickColorRing

extension MomoUI {
    struct JoystickColorRing: View {
        @Environment(\.joystickStyle) var joystickStyle
        @Binding var showHomeScreen: Bool
        @Binding var isDragging: Bool
        @State var hueOn: Bool = false

        var body: some View {
            ZStack {
                Circle()
                    .stroke(self.gradient, lineWidth: self.joystickStyle.ringLineWidth)
                    .frame(width: self.joystickStyle.ringRadius,
                           height: self.joystickStyle.ringRadius)
                    .hueRotation(.degrees(self.hueOn ? 360 : 0))
                    .animation(.shiftColors(while: self.hueOn))
            }
            .onAppear { self.hueOn = true }
            .blur(radius: self.blurRadius)
            .opacity(self.showHomeScreen ? 0 : 1)
            .scaleEffect(self.scaleEffect)
            .onChange(of: self.isDragging) { isDragging in
                self.hueOn = !isDragging
            }
        }

        // MARK: Helper vars

        private var gradient: LinearGradient {
            self.isDragging
                ? LinearGradient(.momo(.joystickMomoRing), direction: .diagonal)
                : LinearGradient(.momo(.joystickColorRing), direction: .diagonal)
        }

        private var blurRadius: CGFloat {
            self.showHomeScreen ? self.joystickStyle.ringBlurRadius : 0
        }

        private var scaleEffect: CGFloat {
            self.showHomeScreen ? self.joystickStyle.ringScaleEffect : 1
        }
    }
}

// MARK: - Animation+Extension

extension Animation {
    /// Creates a shifting color animation effect.
    /// - Parameter expression: Animate while this expression is `true`.
    /// - Returns: An `Animation` instance.
    public static func shiftColors(while expression: Bool) -> Animation {
        return Animation
            .easeInOut(duration: expression ? 4 : 0)
            .repeat(while: expression, autoreverses: false)
    }
}
