//
//  CircleButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-16.
//

import SwiftUI

struct CircleButton: View {
    @Binding var isDragging: Bool
    @State var isAnimating = false
    
    var body: some View {
        ZStack {
            // Dragging Heartbeat
//            Circle()
//                .fill(Color(#colorLiteral(red: 0.6274509804, green: 0.7176470588, blue: 0.8117647059, alpha: 1)))
//                .frame(width: 60, height: 60)
//                .scaleEffect(isDragging ? 1.6: 1.4)
//                .opacity(isDragging ? 1 : 0)
//                .animation(Animation
//                            .easeInOut(duration: 1.2)
//                            .delay(0.2)
//                )
                
            
            
            
            
            Circle()
                .fill(Color(#colorLiteral(red: 0.3529411765, green: 0.6549019608, blue: 0.5294117647, alpha: 1)))
                .frame(width: 70, height: 70)
                .scaleEffect(self.isAnimating ? 1.4: 1)
                .animation(Animation
                            .easeInOut(duration: 1.2)
                            .repeat(while: isAnimating)
                )
            Circle()
                .fill(Color(#colorLiteral(red: 0.4196078431, green: 0.8745098039, blue: 0.5960784314, alpha: 1)))
                .frame(width: 70, height: 70)
                .scaleEffect(self.isAnimating ? 1.2 : 1)
                .animation(Animation
                            .easeInOut(duration: 1.2)
                            .repeat(while: isAnimating)
                            .delay(0.2)
                )
            Circle()
                .fill(Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)))
                .frame(width: 60, height: 60)
                .scaleEffect(self.isAnimating ? 1 : 1.4)
                .shadow(color: Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)), radius: self.isAnimating ? 0 : 2, x: 0, y: 0)
                .animation(Animation
                            .easeInOut(duration: 1.2)
                            .repeat(while: isAnimating)
                )
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isAnimating = true
                self.isDragging = false
            }
        }
        .onChange(of: isDragging) { value in
            self.isAnimating = value ? false : true
        }
        .shadow(color: Color.black.opacity(0.2), radius: 50, x: 10, y: 10)
    }
}
