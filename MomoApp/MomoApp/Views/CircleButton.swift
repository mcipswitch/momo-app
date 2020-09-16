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
            Circle()
                .fill(Color(#colorLiteral(red: 0.3529411765, green: 0.6549019608, blue: 0.5294117647, alpha: 1)))
                .frame(width: 60, height: 60)
                .scaleEffect(self.isAnimating ? 1.4: 1)
                .animation(isAnimating ?
                            Animation
                            .easeInOut(duration: 1.2)
                            .repeatForever(autoreverses: true)
                            : .default
                )
            Circle()
                .fill(Color(#colorLiteral(red: 0.4196078431, green: 0.8745098039, blue: 0.5960784314, alpha: 1)))
                .frame(width: 60, height: 60)
                .scaleEffect(self.isAnimating ? 1.2 : 1)
                .animation(isAnimating ?
                            Animation
                            .easeInOut(duration: 1.2)
                            .repeatForever(autoreverses: true)
                            .delay(0.2)
                            : .default
                )
            Circle()
                .fill(Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)))
                .frame(width: 50, height: 50)
                .scaleEffect(self.isAnimating ? 1 : 1.1)
                .animation(isAnimating ?
                            Animation
                            .easeInOut(duration: 1.2)
                            .repeatForever(autoreverses: true)
                            : .default
                )
        }
        .onAppear {
            self.isAnimating = true
            self.isDragging = false
        }
//        .onChange(of: isDragging) { value in
//            self.isAnimating = value ? false : true
//        }
        .shadow(color: Color.black.opacity(0.6), radius: 50, x: 10, y: 10)
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        CircleButton(isDragging: .constant(false))
    }
}
