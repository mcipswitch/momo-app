//
//  ContentView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    
    let frameSize: CGFloat = 250
    let pathBounds = UIBezierPath.calculateBounds(paths: [.blob1, .blob2, .blob3, .blob4])
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 80) {
                    ZStack(alignment: .center) {
                        if text.isEmpty {
                            Text("My day in a word")
                                .font(.title)
                                .foregroundColor(Color.black.opacity(0.2))
                        }
                        TextField("", text: $text)
                            .font(.title)
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                            .multilineTextAlignment(.center)
                            .accentColor(Color(#colorLiteral(red: 0.4196078431, green: 0.8745098039, blue: 0.5960784314, alpha: 1)))
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 4)
                            .padding(.top, 64)
                    }
                    .frame(width: 220, height: 100)
                    
                    Blob(bezier: .blob4, pathBounds: pathBounds)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.6549019608, green: 0.4392156863, blue: 0.937254902, alpha: 1)), Color(#colorLiteral(red: 0.2039215686, green: 0.5803921569, blue: 0.9019607843, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .position(CGPoint(x: frameSize, y: frameSize))
                        .frame(width: frameSize, height: frameSize * pathBounds.height/pathBounds.width)
                        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 20, y: 20)
                    
                    ZStack {
                        ArcView()
                        CircleButton()
                            .offset(y: geometry.size.width/8 - geometry.size.width/8)
                    }
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

struct ArcView: View {
    var body: some View {
        Arc(startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 180), clockwise: true)
            .scale(1.1)
            .stroke(Color(#colorLiteral(red: 0.2196078431, green: 0.1568627451, blue: 0.4117647059, alpha: 1)), lineWidth: 12)
            .background(Color.black.opacity(0.2))
    }
}

struct CircleButton: View {
    @GestureState var tap = false
    @State var press = false
    @State var animate = false
    @State var fade: Double = 0.5
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(#colorLiteral(red: 0.3529411765, green: 0.6549019608, blue: 0.5294117647, alpha: 1)).opacity(animate ? 1 : fade))
                .frame(width: 70, height: 70)
                .scaleEffect(self.animate ? 1.3: 1)
            Circle()
                .fill(Color(#colorLiteral(red: 0.4196078431, green: 0.8745098039, blue: 0.5960784314, alpha: 1)).opacity(animate ? 1 : fade))
                .frame(width: 70, height: 70)
                .scaleEffect(self.animate ? 1.3 : 1)
                .animation(Animation.easeInOut(duration: 1.2)
                            .repeatForever(autoreverses: true).delay(0.2))
            Circle()
                .fill(Color(#colorLiteral(red: 0, green: 1, blue: 0.7137254902, alpha: 1)).opacity(self.animate ? fade : 1))
                .frame(width: 60, height: 60)
        }
        .onAppear { self.animate = true }
        .animation(Animation.easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 20, y: 20)
        .scaleEffect(tap ? 1.2 : 1)
        .gesture(
            LongPressGesture().updating($tap) { currentState, gestureState, transaction in
                gestureState = currentState
            }
            .onEnded { value in
                self.press.toggle()
            }
        )
    }
}
