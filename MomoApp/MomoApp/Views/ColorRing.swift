//
//  CircleRing.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-24.
//

// https://nerdyak.tech/development/2019/09/30/animating-gradients-swiftui.html

import SwiftUI

struct ColorRing: View {
    @State var size: CGFloat
    @Binding var shiftColors: Bool
    @Binding var isDragging: Bool

    var body: some View {
        // TODO: - Maybe adjust colors later
        let gradient = Gradient(colors: [Color(#colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.7960784314, green: 0.5411764706, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.431372549, green: 0.4901960784, blue: 0.9843137255, alpha: 1))])
        let ring = LinearGradient(gradient: gradient,
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
        
        ZStack {
            Circle()
                .stroke(ring, lineWidth: 6)
                .frame(width: size + 16, height: size + 16)
                .hueRotation(.degrees(shiftColors ? 360 : 0))
                .animation(Animation
                            .easeInOut(duration: shiftColors ? 4 : 1)
                            .repeat(while: shiftColors, autoreverses: false)
                )
            // When user drags joystick, ring will turn green
            Circle()
                .stroke(Color.momo, lineWidth: 6)
                .frame(width: size + 16, height: size + 16)
                .opacity(isDragging ? 1 : 0)
                .animation(.ease())
        }
        .blur(radius: shiftColors ? 0 : 2)
        .opacity(shiftColors ? 1 : 0)
        .scaleEffect(shiftColors ? 1 : 1.1)
    }
}

// MARK: - Previews

struct ColorRing_Previews: PreviewProvider {
    static var previews: some View {
        ColorRing(size: CGFloat(64), shiftColors: .constant(true), isDragging: .constant(false))
    }
}
