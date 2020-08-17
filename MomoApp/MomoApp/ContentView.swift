//
//  ContentView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

import SwiftUI

struct ContentView: View {
    let frameSize: CGFloat = 250
    let pathBounds = UIBezierPath.calculateBounds(paths: [.blob1, .blob2, .blob3, .blob4])
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GradientView()
                VStack(spacing: 32) {
                    Blob(bezier: .blob4, pathBounds: pathBounds)
                        .fill(Color.orange)
                        .position(CGPoint(x: frameSize, y: frameSize))
                        .frame(width: frameSize, height: frameSize * pathBounds.height/pathBounds.width)
                    ZStack {
                        CircleButton()
                    }
                    
                    
                    
                    //                    Circle()
                    //                        .trim(from: 1/2, to: 1.0)
                    //                        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    //                        .offset(y: 300)
                    //                        .frame(width: geometry.size.width, height: 500)
                    //                        .foregroundColor(.orange)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CircleButton: View {
    @State var tap = false
    @State var press = false
    @State var animate = false
    @State var fade: Double = 0.3
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(#colorLiteral(red: 0.3529411765, green: 0.6549019608, blue: 0.5294117647, alpha: 1)).opacity(animate ? 1 : fade))
                .frame(width: 60, height: 60)
                .scaleEffect(self.animate ? 1.3: 1)
            Circle()
                .fill(Color(#colorLiteral(red: 0.4196078431, green: 0.8745098039, blue: 0.5960784314, alpha: 1)).opacity(animate ? 1 : fade))
                .frame(width: 60, height: 60)
                .scaleEffect(self.animate ? 1.3: 1)
                .animation(Animation.easeInOut(duration: 1.2)
                            .repeatForever(autoreverses: true).delay(0.3))
            Circle()
                .fill(Color(#colorLiteral(red: 0, green: 1, blue: 0.7137254902, alpha: 1))).opacity(self.animate ? fade : 1)
                .frame(width: 50, height: 50)
        }
        .onAppear { self.animate = true }
        .animation(Animation.easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true))
        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 20, y: 20)
    }
}
