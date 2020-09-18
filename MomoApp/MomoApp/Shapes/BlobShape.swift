//
//  Blob.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

/*
 Inspired by Code Disciple post...
 http://www.code-disciple.com/creating-smooth-animation-like-headspace-app/
 and Stewart Lynch YouTube video:
 https://www.youtube.com/watch?v=IUpN7sIwaqc
 and The SwiftUI Lab post:
 https://swiftui-lab.com/swiftui-animations-part1/
 */

import SwiftUI
import Combine

struct BlobEffect: GeometryEffect {
    var skewValue: CGFloat
    //private var a: CGFloat { CGFloat(Angle(degrees: angle).radians) }
    
    var animatableData: CGFloat {
        get { skewValue }
        set { skewValue = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        //var skew: CGFloat { cos(skewValue + .pi / 2) * 0.1 }
        var skew: CGFloat { skewValue * 0.03 }
        
        // m34: sets the perspective parameter
        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1 / max(size.width, size.height)
        // Transform: Rotate
        //transform3d = CATransform3DRotate(transform3d, a, 0, 0, 1)
        // Transform: Scale
        //transform3d = CATransform3DScale(transform3d, scaleFactor, 1, 0)
        // Transform: Shifts anchor point of rotation (from top leading corner to centrer)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
        // Transform: Skew
        let skewTransform = ProjectionTransform(CGAffineTransform(a: 1, b: 0, c: skew, d: 1, tx: 0, ty: 0))
        // Transform: Shifts back to center
        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
        return ProjectionTransform(transform3d).concatenating(skewTransform).concatenating(affineTransform)
    }
}

struct BlobView: View {
    @State var isAnimating = false
    
    let frameSize: CGFloat
    let pathBounds = UIBezierPath.calculateBounds(paths: [.blob3])
    var duration: Double = 1
    
    @Binding var pct: CGFloat
    @State var percentage: CGFloat = 0
    @State var firstHalf = true
    
    let gradient1: [UIColor] = [#colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 1, alpha: 1), #colorLiteral(red: 0.7960784314, green: 0.5411764706, blue: 1, alpha: 1), #colorLiteral(red: 0.431372549, green: 0.4901960784, blue: 0.9843137255, alpha: 1)]
    //let gradient2: [UIColor] = [#colorLiteral(red: 0.8352941176, green: 1, blue: 0.8196078431, alpha: 1), #colorLiteral(red: 0.7411764706, green: 1, blue: 0.5411764706, alpha: 1), #colorLiteral(red: 0.4823529412, green: 0.8156862745, blue: 0.2039215686, alpha: 1)]
    let gradient2: [UIColor] = [#colorLiteral(red: 1, green: 0.9019607843, blue: 0.8196078431, alpha: 1), #colorLiteral(red: 1, green: 0.6705882353, blue: 0.5411764706, alpha: 1), #colorLiteral(red: 0.9843137255, green: 0.431372549, blue: 0.4588235294, alpha: 1)]
    let gradient3: [UIColor] = [#colorLiteral(red: 0.9921568627, green: 0.9960784314, blue: 0.8, alpha: 1), #colorLiteral(red: 0.9960784314, green: 0.4745098039, blue: 0.6078431373, alpha: 1), #colorLiteral(red: 0.8274509804, green: 0.1843137255, blue: 0.2862745098, alpha: 1)]
    
    var body: some View {
        ZStack {
            // Blob: Shadow Layer
            BlobShape(bezier: .blob3, pathBounds: pathBounds)
                .fill(Color.clear)
                .shadow(color: Color.black.opacity(0.6), radius: 50, x: 10, y: 10)
                .modifier(BlobEffect(
                    skewValue: isAnimating ? 2 : 0
                ))
                // Skew Effect
                .animation(Animation
                            .easeInOut(duration: duration)
                            .repeat(while: isAnimating)
                )
                // Breathe Effect
                .scaleEffect(isAnimating ? 1.05 : 1)
                .animation(Animation
                            .timingCurve(0.4, 0, 0.4, 1, duration: 4)
                            .repeat(while: isAnimating)
                )
            // Blob: Gradient Layer
            ZStack {
                Rectangle()
                    .modifier(AnimatableGradient(from: gradient1, to: gradient2, pct: pct, startRadius: 100, endRadius: pathBounds.width * 1.3)) // 120 * 1.5
            }
            .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
            .mask(
                BlobShape(bezier: .blob3, pathBounds: pathBounds)
                    .modifier(BlobEffect(
                        skewValue: isAnimating ? 2 : 0
                    ))
                    // Skew Effect
                    .animation(Animation
                                .easeInOut(duration: duration)
                                .repeat(while: isAnimating)
                    )
                    // Breathe Effect
                    .scaleEffect(isAnimating ? 1.05 : 1)
                    .animation(Animation
                                .timingCurve(0.4, 0, 0.4, 1, duration: 4)
                                .repeat(while: isAnimating)
                    )
                    // Rotate Effect
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(Animation
                                .linear(duration: 50)
                                .repeatForever(autoreverses: false)
                    )
            )
            
//            VStack {
//                Text("\(percentage)")
//            }
//            .padding(.bottom, 50)
        }
        .frame(width: frameSize, height: frameSize * (pathBounds.width / pathBounds.height))
        .onAppear {
            isAnimating = true
        }
//        .onChange(of: self.pct) { value in
//            if value <= 0.5 {
//                self.firstHalf = true
//                self.percentage = pct * 2
//            } else {
//                self.firstHalf = false
//                self.percentage = pct * 2 - 1
//            }
//        }
    }
}

// MARK: - Blob Shape

struct BlobShape: Shape {
    let bezier: UIBezierPath
    let pathBounds: CGRect
    
    func path(in rect: CGRect) -> Path {
        let centerPoint = CGPoint(x: rect.midX, y: rect.midY)
        
        // Scale down points to between 0 and 1
        let pointScale = (rect.width >= rect.height) ?
            max(pathBounds.height, pathBounds.width) :
            min(pathBounds.height, pathBounds.width)
        let pointTransform = CGAffineTransform(scaleX: 1/pointScale, y: 1/pointScale)
        let path = Path(bezier.cgPath).applying(pointTransform)
        
        // Ensure path will fit inside the rectangle that shape is contained in
        let multiplier = min(rect.width, rect.height)
        let scale = CGAffineTransform(scaleX: multiplier, y: multiplier)
        
        // Center the blob inside the rectangle
        let position = scale.concatenating(CGAffineTransform(translationX: centerPoint.x, y: centerPoint.y))
        return path.applying(position)
    }
}

// MARK: - Previews

struct Blob_Previews: PreviewProvider {
    static var previews: some View {
        BlobView(frameSize: 250, pct: .constant(0.1))
    }
}









//    var speedMin: Double = 1
//    var speedMax: Double = 24
//    @State var speed: Double = 1
//
//    var skewValueMin: CGFloat = 2
//    var skewValueMax: CGFloat = 8
//    @State var skewValue: CGFloat = 0
//
//    var scaleMin: CGFloat = 1
//    var scaleMax: CGFloat = 1.05
//    @State var scaleFactor: CGFloat = 1
