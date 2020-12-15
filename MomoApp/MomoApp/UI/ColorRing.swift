//
//  ColorRing.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-24.
//

// https://nerdyak.tech/development/2019/09/30/animating-gradients-swiftui.html

import SwiftUI

struct ColorRing: View {
    typealias Ring = MSK.Joystick.Ring

    @Binding var isAnimating: Bool
    @Binding var isDragging: Bool
    @State var on: Bool = false

    var body: some View {
        let colorGradient = LinearGradient(gradient: .colorRingGradient,
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
        let momoGradient = LinearGradient(gradient: .momoRingGradient,
                                      startPoint: .topLeading,
                                      endPoint: .bottomTrailing)

        ZStack {
            Circle()
                .stroke(isDragging ? momoGradient : colorGradient, lineWidth: Ring.lineWidth)
                .frame(width: Ring.size, height: Ring.size)
                .hueRotation(.degrees(on ? 360 : 0))
                .animation(.shiftColors(while: on))
        }
        .onAppear {
            on = true
        }
        .blur(radius: isAnimating ? 0 : Ring.blurRadius)
        .opacity(isAnimating ? 1 : 0)
        .scaleEffect(isAnimating ? 1 : Ring.scaleEffect)
        .onChange(of: isDragging) { isDragging in
            on = isDragging ? false : true
        }
    }
}

// MARK: - Joystick

extension MSK.Joystick {
    static let defaultSize: CGFloat = 80

    struct Ring {
        static let blurRadius: CGFloat = 2
        static let lineWidth: CGFloat = 6
        static let scaleEffect: CGFloat = 1.1
        static let size: CGFloat = MSK.Joystick.defaultSize + 16
    }
}
