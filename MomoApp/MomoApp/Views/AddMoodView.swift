//
//  AddMoodProfile.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-17.
//

import SwiftUI
import Combine

struct AddMoodView: View {
    @ObservedObject private var animator = Animator()
    
    // MARK: - Properties and Variables
    @GestureState var isLongPressed = false
    @State var isSelecting = false
    @State var isReset = true
    @State var isResetting = false
    
//    @ObservedObject private var textLimiter = TextLimiter(limit: 5)
    @State private var text = ""
    let timer = Timer.publish(every: 0.01, on: RunLoop.main, in: .common).autoconnect()
    
    @State var forceValue: CGFloat = 0.0
    @State var maxForceValue: CGFloat = 0.0
    @State var pct: Double = 0
    
    
    @State private var intensity: Double = 0
    
    
    // MARK: - Body
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 64) {
                    ZStack(alignment: .center) {
                        if text.isEmpty {
                            Text("My day in a word")
                                .font(Font.system(size: 28, weight: .semibold))
                                .foregroundColor(Color.white.opacity(0.6))
                                .blur(radius: 0.5)
                        }
                        TextField("", text: $text)
                            .textFieldStyle(CustomTextFieldStyle())
                            .onReceive(text.publisher.collect()) { characters in
                                self.text = String(text.prefix(20))
                            }
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 2)
                            .padding(.top, 48)
                    }
                    .frame(width: 230)
                    .padding(.top, 32)
                    
                    
                    
                    
                    ZStack {
                        BlobView(frameSize: geometry.size.width * 0.7, speed: $animator.speed, skewValue: $animator.skewValue)
                        
                        VStack {
//                            Text("Force Touch Value")
//                            Text("\(pct)")
//                                .onChange(of: self.forceValue) { value in
//                                    if value != 0.0 {
//                                        self.pct = (value * 100) / self.maxForceValue
//                                    }
//                                }
                            Text("Intensity: \(intensity)")
                        }
                    }
                    
                    CustomSlider(percentage: $intensity)
                        .padding(.horizontal, 40)
                        .frame(height: 80)
                    
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
                                    .trim(from: 0, to: 1)
                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.6039215686, green: 0.9411764706, blue: 0.8823529412, alpha: 1)), Color(#colorLiteral(red: 0.1882352941, green: 0.8039215686, blue: 0.6156862745, alpha: 1))]), startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                    .shadow(color: Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)), radius: 5, x: 0, y: 0)
                                    .rotation3DEffect(
                                        Angle(degrees: 180),
                                        axis: (x: 0, y: 1, z: 0)
                                    )
                                    .animation(Animation.easeOut(duration: 0.2))
                            }
                            .frame(height: geometry.size.width/2 + 6)
                            .scaleEffect(1.05)
                            
                            CircleButton(forceValue: $forceValue, maxForceValue: $maxForceValue)
                                .padding(.top, 50)
                            
                            
                            
                            
//                                .gesture(
//                                    LongPressGesture(minimumDuration: 0.2, maximumDistance: 100)
//                                        .onChanged { _ in
//                                            if !isSelecting && !isReset {
//                                                print("Resetting...")
//                                                self.animator.counter = 0
//                                                self.isResetting = true
//                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                                                    self.animator.counter = 0
//                                                    self.isResetting = false
//                                                }
//                                            }
//                                            self.isReset.toggle()
//                                            self.isSelecting = true
//                                        }.onEnded { value in
//                                            if isReset {
//                                                self.isReset.toggle()
//                                            }
//                                        }
//                                )
//                                .simultaneousGesture(
//                                    DragGesture(minimumDistance: 0)
//                                        .onEnded { value in
//                                            self.animator.counter -= 0.02
//                                            self.isSelecting = false
//                                        }
//                                )
//                                .onReceive(timer) { _ in
//                                    if self.isSelecting {
//                                        guard self.animator.counter < (CGFloat(duration)) else { return }
//                                        self.animator.counter += 0.01
//                                    }
//                                }
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
    
    @Binding var forceValue: CGFloat
    @Binding var maxForceValue: CGFloat
    
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
                        .repeatForever(autoreverses: true).delay(0.2)
                )
            CustomView(tappedForceValue: $forceValue, maxForceValue: $maxForceValue)
                .background(Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)))
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
                .scaleEffect(self.isAnimating ? 1 : 1.1)
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
