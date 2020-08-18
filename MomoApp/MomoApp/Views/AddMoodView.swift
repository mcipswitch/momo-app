//
//  AddMoodProfile.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-17.
//

import SwiftUI

struct AddMoodView: View {
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
            VStack(spacing: 64) {
                ZStack(alignment: .center) {
                    if text.isEmpty {
                        Text("My day in a word")
                            .font(.title).fontWeight(.semibold)
                            .foregroundColor(Color.white.opacity(0.3))
                    }
                    TextField("", text: $text)
                        .font(Font.system(size: 32, weight: .semibold))
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        .multilineTextAlignment(.center)
                        .accentColor(Color(#colorLiteral(red: 0.4196078431, green: 0.8745098039, blue: 0.5960784314, alpha: 1)))
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 4)
                        .padding(.top, 64)
                }
                .frame(width: 230)
                .padding(.top, 32)
                
                BlobView()
                
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        
                        ZStack(alignment: .top) {
                            ZStack {
                                Rectangle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2549019608, green: 0.2039215686, blue: 0.4823529412, alpha: 1)), Color(#colorLiteral(red: 0.01568627451, green: 0.01176470588, blue: 0.07058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                                    .clipShape(
                                        Arc().offset(y: 6)
                                    )
                                Arc()
                                    .stroke(Color.black.opacity(0.2), lineWidth: 12)
                                Arc()
                                    .trim(from: 0.0, to: 0.5)
                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1882352941, green: 0.8039215686, blue: 0.6156862745, alpha: 1)), Color(#colorLiteral(red: 0.6039215686, green: 0.9411764706, blue: 0.8823529412, alpha: 1))]), startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                    .shadow(color: Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)), radius: 5, x: 0, y: 0)
                                    .rotation3DEffect(
                                        Angle(degrees: 180),
                                        axis: (x: 0, y: 1, z: 0)
                                    )
                            }
                            .frame(height: geometry.size.width/2 + 6)
                            //.background(Color.orange)
                            .scaleEffect(1.1)
                            
                            CircleButton()
                                .padding(.top, 50)
                        }
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
        }
        .navigationBarItems(trailing: NextButton())
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

struct AddMoodProfile_Previews: PreviewProvider {
    static var previews: some View {
        AddMoodView()
    }
}

struct NextButton: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(#colorLiteral(red: 0, green: 1, blue: 0.7137254902, alpha: 1)))
                .frame(width: 100, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
            HStack {
                Text("Next")
                    .font(.body).fontWeight(.bold)
                Image(systemName: "arrow.right")
                    .font(Font.system(size: 15, weight: .heavy))
            }
        }
    }
}
