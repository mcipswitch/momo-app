//
//  Blob.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

import SwiftUI

/*
 Inspired by Code Disciple post...
 http://www.code-disciple.com/creating-smooth-animation-like-headspace-app/
 and Stewart Lynch YouTube video:
 https://www.youtube.com/watch?v=IUpN7sIwaqc
 */

struct BlobEffect: GeometryEffect {
    var skewBaseTime = 0.1
    let upscale = 5.0
    let scaleAdjustment = 0.1
    
    var offsetValue: CGFloat
    var angle: CGFloat
    public var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get {
            AnimatablePair(CGFloat(offsetValue), CGFloat(angle))
        }
        set {
            offsetValue = newValue.first
            angle =  newValue.second
        }
    }
    
    // Called continuously during interpolation
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        // Transform: Rotate
        //.rotationEffect(isAnimating ? Angle(degrees: 360) : Angle(degrees: 0), anchor: .center)
        
        
        // Transform: Scale
        
        
        
        // Transform: Skew
        let skewTransform = CGAffineTransform(a: 1.0, b: CGFloat(cos(offsetValue + .pi / 2) * 0.1), c: CGFloat(cos(offsetValue + .pi / 2) * 0.1), d: 1.0, tx: 0.0, ty: 0.0)
        return ProjectionTransform(skewTransform)
    }
}

struct BlobView: View {
    @State var isAnimating = false
    let frameSize: CGFloat = 250
    let pathBounds = UIBezierPath.calculateBounds(paths: [.blob3])
    
    var body: some View {
        ZStack {
            Blob(bezier: .blob3, pathBounds: pathBounds)
                .fill(RadialGradient(
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 1, alpha: 1)),  Color(#colorLiteral(red: 0.7960784314, green: 0.5411764706, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.431372549, green: 0.4901960784, blue: 0.9843137255, alpha: 1))]),
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: pathBounds.width * 1.5)
                )
                .frame(width: frameSize, height: frameSize * pathBounds.width / pathBounds.height)
                .shadow(color: Color.black.opacity(0.6), radius: 50, x: 10, y: 10)
                
                // Animation
                .modifier(BlobEffect(offsetValue: isAnimating ? 10 : 0, angle: isAnimating ? CGFloat.pi * 2 : 0))
                .animation(Animation.linear(duration: 24.0).repeatForever(autoreverses: false))
                .onAppear {
                    isAnimating = true
                }
        }
    }
}

struct Blob: Shape {
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

struct Blob_Previews: PreviewProvider {
    static var previews: some View {
        BlobView()
    }
}
