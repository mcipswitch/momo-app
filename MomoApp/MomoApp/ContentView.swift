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
    let pathBounds = UIBezierPath.calculateBounds(paths: [.blob1])
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                    .edgesIgnoringSafeArea(.all)
            }
            VStack {
                Spacer(minLength: 16)
                ZStack(alignment: .center) {
                    if text.isEmpty {
                        Text("My day in a word")
                            .font(.title)
                            .foregroundColor(Color.white.opacity(0.2))
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
                .frame(width: 220)
                
                BlobView()
                    .padding(64)
                
                GeometryReader { geometry in
                    ZStack(alignment: .top) {
                        ArcView()
                        CircleButton()
                            .padding(.top, 48)
                    }
                    .frame(height: geometry.size.width/2)
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
    let lineWidth: CGFloat = 12
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Arc()
                    .stroke(Color.black.opacity(0.2), lineWidth: lineWidth)
                Arc(startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: true)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2549019608, green: 0.2039215686, blue: 0.4823529412, alpha: 1)), Color(#colorLiteral(red: 0.01568627451, green: 0.01176470588, blue: 0.07058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                    .offset(y: lineWidth/2)
            }
            .frame(height: geometry.size.width/2)
            .scaleEffect(1.1)
        }
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
        .shadow(color: Color.black.opacity(0.6), radius: 50, x: 10, y: 10)
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
