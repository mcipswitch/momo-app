//
//  CircleButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-16.
//
import SwiftUI



















//struct CircleButton: View {
//    @Binding var isDragging: Bool
//    @Binding var isAnimating: Bool
//
//    var body: some View {
//        ZStack {
//            Circle()
//                .fill(
//                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.431372549, green: 0.4901960784, blue: 0.9843137255, alpha: 1)), Color(#colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 1, alpha: 1))]),
//                                   startPoint: .topLeading, endPoint: .bottomTrailing)
//                )
//                .scaleEffect(isDragging ? 1.6 : 1.4)
//                .opacity(isDragging ? 0.5 : 0)
//                .animation(isDragging ? .default : .spring())
//            Circle()
//                .fill(Color(#colorLiteral(red: 0.3529411765, green: 0.6549019608, blue: 0.5294117647, alpha: 1)))
//                .scaleEffect(isAnimating ? 1.5 : 1)
//                .animation(isAnimating ?
//                            Animation
//                            .easeInOut(duration: 1.2)
//                            .repeat(while: isAnimating)
//                            : (isDragging ? .default : .spring())
//                )
//            Circle()
//                .fill(Color(#colorLiteral(red: 0.4196078431, green: 0.8745098039, blue: 0.5960784314, alpha: 1)))
//                .scaleEffect(isAnimating ? 1.3: 1)
//                .animation(isAnimating ?
//                            Animation
//                            .easeInOut(duration: 1.2)
//                            .repeat(while: isAnimating)
//                            .delay(isAnimating ? 0.2 : 0)
//                            : (isDragging ? .default : .spring())
//                )
//            Circle()
//                .fill(Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)))
//                .scaleEffect(isAnimating ? 1 : 1.4)
//                .animation(isAnimating ?
//                            Animation
//                            .easeInOut(duration: 1.2)
//                            .repeat(while: isAnimating)
//                            : (isDragging ? .default : .spring())
//                )
//        }
//        .onChange(of: isDragging) { value in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
//                self.isAnimating = value ? false : true
//            }
//        }
//        .frame(width: 60, height: 60)
//    }
//}
