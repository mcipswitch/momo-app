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
 */

import SwiftUI

struct BlobEffect: GeometryEffect {
    var animatableData: AnimatablePair<CGFloat, Double> {
        get { AnimatablePair(CGFloat(offsetValue), Double(angle)) }
        set {
            offsetValue = newValue.first
            angle =  newValue.second
        }
    }

    var offsetValue: CGFloat
    var angle: Double
    let axis: (x: CGFloat, y: CGFloat)
    
    var a: CGFloat { CGFloat(Angle(degrees: angle).radians) }
    
    // Called continuously during interpolation
    func effectValue(size: CGSize) -> ProjectionTransform {
        // m34: sets the perspective parameter
        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1 / max(size.width, size.height)
        
        // Transform: Scale
        //transform3d = CATransform3DScale(transform3d, scaleFactor, scaleFactor, 0)
        // Transform: Rotate
        transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 1)
        // The default anchor point is at the top leading corner.
        // Transform: Shifts anchor of rotation
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
        // Transform: Skew
        let skewTransform = ProjectionTransform(
            CGAffineTransform(a: 1, b: 0, c: cos(offsetValue + .pi / 2) * 0.1, d: 1, tx: 0, ty: 0)
        )
        // Transform: Shifts back to center
        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
        
        return ProjectionTransform(transform3d).concatenating(skewTransform).concatenating(affineTransform)
    }
}

struct BlobView: View {
    @State var isAnimating = false
    let frameSize: CGFloat = 200
    let pathBounds = UIBezierPath.calculateBounds(paths: [.blob3])
    var offsetValue: CGFloat = 100.0
    
    var body: some View {
        ZStack {
            Blob(bezier: .blob2, pathBounds: pathBounds)
                .fill(Color.orange)
//                .fill(RadialGradient(
//                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 1, alpha: 1)),  Color(#colorLiteral(red: 0.7960784314, green: 0.5411764706, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.431372549, green: 0.4901960784, blue: 0.9843137255, alpha: 1))]),
//                        center: .topLeading,
//                        startRadius: 0,
//                        endRadius: pathBounds.width * 1.5)
//                )
                .frame(width: frameSize, height: frameSize * pathBounds.width / pathBounds.height)
                //.shadow(color: Color.black.opacity(0.6), radius: 50, x: 10, y: 10)
                
                // Animation
                .modifier(BlobEffect(offsetValue: isAnimating ? offsetValue : 0, angle: isAnimating ? 360 : 0, axis: (x: 0, y: 0)))
                
                
                
                //.rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                
                
                .animation(
                    Animation
                        .linear(duration: 12) // 2 to 48
                        .repeatForever(autoreverses: false)
                )
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
