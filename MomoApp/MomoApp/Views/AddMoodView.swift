//
//  AddMoodProfile.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-17.
//

import SwiftUI
import Combine

struct AddMoodView: View {
    let universalSize = UIScreen.main.bounds
    
    @State private var text: String = ""
    @GestureState var longPressTap = false
    @State var isPressed = false
    @State var isTapped = false
    @ObservedObject var input = TextLimiter(limit: 5)
    
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
                            .foregroundColor(Color.white.opacity(0.5))
                    }
                    TextField("", text: $input.text)
//                        .onReceive(text.publisher.collect()) {
//                            self.text = String($0.prefix(5))
//                        }
                        .border(Color.red, width: input.hasReachedLimit ? 1 : 0)
                        
                        
                    

                        .font(Font.system(size: 32, weight: .semibold))
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        .multilineTextAlignment(.center)
                        .accentColor(Color(#colorLiteral(red: 0.4196078431, green: 0.8745098039, blue: 0.5960784314, alpha: 1)))
                        .minimumScaleFactor(0.5)
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 2)
                        .padding(.top, 48)
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
                                        ArcShape().offset(y: 6)
                                    )
                                ArcShape()
                                    .stroke(Color.black.opacity(0.2), lineWidth: 12)
                                ArcShape()
                                    .trim(from: 0, to: longPressTap ? 1 : 0.001)
                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.6039215686, green: 0.9411764706, blue: 0.8823529412, alpha: 1)), Color(#colorLiteral(red: 0.1882352941, green: 0.8039215686, blue: 0.6156862745, alpha: 1))]), startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                    .shadow(color: Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)), radius: 5, x: 0, y: 0)
                                    .rotation3DEffect(
                                        Angle(degrees: 180),
                                        axis: (x: 0, y: 1, z: 0)
                                    )
                                    .animation(.linear(duration: 1.0))
                            }
                            .frame(height: geometry.size.width/2 + 6)
                            //.background(Color.orange)
                            .scaleEffect(1.1)
                            
                            CircleButton(isTapped: $isTapped)
                                .padding(.top, 50)
                                .scaleEffect(longPressTap ? 1.1 : 1)
                                .gesture(
                                    LongPressGesture(minimumDuration: 10.0)
                                        .updating($longPressTap) { currentState, gestureState, transaction in
                                        gestureState = currentState
                                            self.isTapped = true
                                    }
                                    .onEnded { value in
                                        self.isPressed.toggle()
                                        self.isTapped = false
                                    }
                                )
                        }
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
        }
        .navigationBarItems(trailing: NextButton())
    }
}

// MARK: - Views

struct CircleButton: View {
    @GestureState var longPressTap = false
    @State var isAnimating = false
    @State var fade: Double = 0.5
    @Binding var isTapped: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(#colorLiteral(red: 0.3529411765, green: 0.6549019608, blue: 0.5294117647, alpha: 1)))
                .frame(width: 60, height: 60)
                .scaleEffect(self.isAnimating ? 1.4: 1)
                .animation(
                    Animation
                        .easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: true)
                )
            Circle()
                .fill(Color(#colorLiteral(red: 0.4196078431, green: 0.8745098039, blue: 0.5960784314, alpha: 1)))
                .frame(width: 60, height: 60)
                .scaleEffect(self.isAnimating ? 1.2 : 1)
                .animation(
                    Animation
                        .easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: true).delay(0.2))
            
            Circle()
                .fill(Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)))
                .scaleEffect(self.isAnimating ? 1 : 1.1)
                .frame(width: 50, height: 50)
                .animation(
                    Animation
                        .easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: true)
                )
        }
        .onAppear { self.isAnimating = true }
        .shadow(color: Color.black.opacity(0.6), radius: 50, x: 10, y: 10)
    }
}

struct NextButton: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)))
                .frame(width: 90, height: 34)
                .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
            HStack {
                Text("Next")
                    .font(Font.system(size: 15, weight: .bold))
                Image(systemName: "arrow.right")
                    .font(Font.system(size: 14, weight: .heavy))
            }
        }
    }
}

// MARK: - Previews

struct AddMoodProfile_Previews: PreviewProvider {
    static var previews: some View {
        AddMoodView()
    }
}
