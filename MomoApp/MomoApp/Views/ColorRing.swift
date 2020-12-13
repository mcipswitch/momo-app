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
    @Binding var shiftColors: Bool
    @Binding var isDragging: Bool

    @State var on: Bool = true

    var body: some View {
        // TODO: - Maybe adjust colors later
        let ring = LinearGradient(gradient: .colorRingGradient,
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
        let momoRing = LinearGradient(gradient: .momoRingGradient,
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
        
        ZStack {
            Circle()
                .stroke(isDragging ? momoRing : ring, lineWidth: Ring.lineWidth)
                .frame(width: Ring.size, height: Ring.size)
                .hueRotation(.degrees(on ? 360 : 0))
                .animation(.shiftColors(while: on))
        }
        .blur(radius: shiftColors ? 0 : Ring.blur)
        .opacity(shiftColors ? 1 : 0)
        .scaleEffect(shiftColors ? 1 : Ring.scaleEffect)
        .onChange(of: isDragging) { isDragging in
            on = isDragging ? false : true
        }

    }
}
