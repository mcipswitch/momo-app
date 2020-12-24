//
//  ColorRing.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-24.
//

// https://nerdyak.tech/development/2019/09/30/animating-gradients-swiftui.html

import SwiftUI

// MARK: - ColorRing

struct ColorRing: View {
    @Environment(\.joystickStyle) var joystickStyle
    @Binding var homeViewActive: Bool
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
        .opacity(self.homeViewActive ? 0 : 1)
        .scaleEffect(self.scaleEffect)
        .onChange(of: self.isDragging) { isDragging in
            self.hueOn = !isDragging
        }
    }

    // MARK: - Helper vars

    private var colorGradient: LinearGradient {
        LinearGradient(.colorRingGradient, direction: .diagonal)
    }

    private var momoGradient: LinearGradient {
        LinearGradient(.momoRingGradient, direction: .diagonal)
    }

    private var gradient: LinearGradient {
        self.isDragging ? self.momoGradient : self.colorGradient
    }

    private var blurRadius: CGFloat {
        self.homeViewActive ? self.joystickStyle.ringBlurRadius : 0
    }

    private var scaleEffect: CGFloat {
        self.homeViewActive ? self.joystickStyle.ringScaleEffect : 1
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
