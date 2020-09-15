//
//  CustomSlider.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-14.
//

import SwiftUI

struct CustomSlider: View {
    @Binding var percentage: CGFloat
    @Binding var isDragging: Bool
    
    let trackGradient = LinearGradient(
        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1882352941, green: 0.8039215686, blue: 0.6156862745, alpha: 1)), Color(#colorLiteral(red: 0.6039215686, green: 0.9411764706, blue: 0.8823529412, alpha: 1))]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
        var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(Color.black.opacity(0.2))
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(trackGradient)
                        .mask(
                            Rectangle()
                                .padding(.trailing, geometry.size.width * CGFloat(1 - self.percentage))
                                .shadow(color: Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)), radius: 5, x: 0, y: 0)  
                        )
                }
                .cornerRadius(20)
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        self.isDragging = true
                        self.percentage = min(max(0, CGFloat(value.location.x / geometry.size.width)), 1)
                    }
                            .onEnded { value in
                                self.isDragging = false
                            }
                )
                .animation(Animation.easeInOut(duration: 0.5))
            }
        }
}

struct CustomSlider_Previews: PreviewProvider {
    static var previews: some View {
        CustomSlider(percentage: .constant(50), isDragging: .constant(false))
    }
}
