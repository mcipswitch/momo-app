//
//  AddMoodProfile.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-17.
//

import SwiftUI
import Combine

struct AddMoodView: View {
    // MARK: - Properties and Variables
    @GestureState var isLongPressed = false
    
//    @ObservedObject private var textLimiter = TextLimiter(limit: 5)
    @State private var text = ""
    
    @State var forceValue: CGFloat = 0.0
    @State var maxForceValue: CGFloat = 0.0

    @State private var intensity: CGFloat = 0
    
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
                        BlobView(frameSize: geometry.size.width * 0.7, pct: $intensity)
                        
                        VStack {
                            Text("Percentage: \(intensity)")
                        }
                    }
                    
                    
                    
                    CustomSlider(percentage: $intensity)
                        .padding(.horizontal, 40)
                        .frame(height: 40)
                    
                    CircleButton(forceValue: $forceValue, maxForceValue: $maxForceValue)
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
