//
//  ColorRing.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-24.
//

// https://nerdyak.tech/development/2019/09/30/animating-gradients-swiftui.html

import SwiftUI

struct ColorRing: View {
    typealias Ring = Momo.Joystick.Ring
    @Binding var isAnimating: Bool
    @Binding var isDragging: Bool
    @State var on: Bool = false

    var body: some View {

        // TODO: - Maybe adjust colors later
        let colorRing = LinearGradient.colorRing
        let momoRing = LinearGradient.momoRing

        ZStack {
            Circle()
                .stroke(isDragging ? momoRing : colorRing, lineWidth: Ring.lineWidth)
                .frame(width: Ring.size, height: Ring.size)
                .hueRotation(.degrees(on ? 360 : 0))
                .animation(.shiftColors(while: on))
        }
        .onAppear { on = true }
        .blur(radius: isAnimating ? 0 : Ring.blur)
        .opacity(isAnimating ? 1 : 0)
        .scaleEffect(isAnimating ? 1 : Ring.scaleEffect)
        .onChange(of: isDragging) { isDragging in
            on = isDragging ? false : true
        }
    }
}
