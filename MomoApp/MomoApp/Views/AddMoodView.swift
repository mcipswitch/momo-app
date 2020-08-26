//
//  AddMoodProfile.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-17.
//

import SwiftUI

struct AddMoodView: View {
    
    // MARK: - Properties and Variables
    let universalSize = UIScreen.main.bounds
    @GestureState var isLongPressed = false
    @State var isLongPressing = false
    @State var counter: CGFloat = 0
    @State var isResetting = false
    let timer = Timer.publish(every: 0.01, on: RunLoop.main, in: .common).autoconnect()
    
    // MARK: - Body

    var body: some View {
        let pct = counter / 8
        
        ZStack {
            GeometryReader { geometry in
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 64) {
                    WordTextField()
                    
                    ZStack {
                        BlobView(frameSize: geometry.size.width * 0.7)
                        Text("\(pct)")
                    }
                    
                    VStack {
                        Spacer()
                        
                        ZStack(alignment: .top) {
                            ZStack {
                                Rectangle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2549019608, green: 0.2039215686, blue: 0.4823529412, alpha: 1)), Color(#colorLiteral(red: 0.01568627451, green: 0.01176470588, blue: 0.07058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                                    .clipShape(
                                        ArcShape().offset(y: 6)
                                    )
                                // Arc: Track Layer
                                ArcShape()
                                    .stroke(Color.black.opacity(0.2), lineWidth: 12)
                                // Arc: Progress Layer
                                ArcShape()
                                    //.trim(from: 0, to: isLongPressing ? 1 : pct)
                                    .trim(from: 0, to: isResetting ? 0 : pct)
                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.6039215686, green: 0.9411764706, blue: 0.8823529412, alpha: 1)), Color(#colorLiteral(red: 0.1882352941, green: 0.8039215686, blue: 0.6156862745, alpha: 1))]), startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                    .shadow(color: Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)), radius: 5, x: 0, y: 0)
                                    .rotation3DEffect(
                                        Angle(degrees: 180),
                                        axis: (x: 0, y: 1, z: 0)
                                    )
                                    .animation(Animation.easeOut(duration: isResetting ? 0.2 : 8))
                            }
                            .frame(height: geometry.size.width/2 + 6)
                            .scaleEffect(1.05)
                            
                            CircleButton()
                                .padding(.top, 50)
                                .gesture(
                                    LongPressGesture(minimumDuration: 0.2)
                                        .updating($isLongPressed) { currentState, gestureState, transaction in
                                            gestureState = currentState
                                        }
                                )
                                .simultaneousGesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            print("Start:", value.time)
                                            if !isLongPressing && counter != 0 {
                                                counter = 0
                                                self.isResetting = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                    self.isResetting = false
                                                }
                                            }
                                            self.isLongPressing = true
                                        }.onEnded { value in
                                            print("End:", value.time)
                                            self.isLongPressing = false
                                        }
                                )
                                .onReceive(timer) { _ in
                                    if isLongPressing {
                                        guard counter < (8 - 0.01) else { return }
                                        counter += 0.01
                                    }
                                }
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
    @State var isAnimating = false
    @State var fade: Double = 0.5

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
            // Center
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

struct WordTextField: View {
    @ObservedObject var textLimiter = TextLimiter(limit: 5)
    
    var body: some View {
        ZStack(alignment: .center) {
            if textLimiter.userInput.isEmpty {
                Text("My day in a word")
                    .font(Font.system(size: 28, weight: .semibold))
                    .foregroundColor(Color.white.opacity(0.7))
                    .blur(radius: 0.5)
            }
            TextField("", text: $textLimiter.userInput)
                .textFieldStyle(CustomTextFieldStyle())
            Rectangle()
                .fill(Color.white)
                .frame(height: 2)
                .padding(.top, 48)
        }
        .frame(width: 230)
        .padding(.top, 32)
    }
}

// MARK: - Previews

struct AddMoodProfile_Previews: PreviewProvider {
    static var previews: some View {
        AddMoodView()
    }
}
