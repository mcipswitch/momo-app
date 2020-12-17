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
import Neumorphic

struct BlobView: View {

    @Binding var blobValue: CGFloat
    @State var isStatic = true
    @State var isAnimating = false
    @State var scale: CGFloat = 1
    
    let pathBounds = UIBezierPath.calculateBounds(paths: [.blob3])

    var animatingBlob: some View {
        BlobShape(bezier: .blob3, pathBounds: pathBounds)
            .modifier(BlobEffect(
                skewValue: isAnimating ? 2 : 0
            ))
            .modifier(BlobAnimationModifier(
                        skew: true,
                        breathe: true,
                        rotate: true,
                        isAnimating: $isAnimating)
            )
    }
    
    var body: some View {
        let frameSize: CGFloat = 250
        let scaledFrame = frameSize * scale
        
        ZStack {
            // Blob: Shadow Layer
            BlobShape(bezier: .blob3, pathBounds: pathBounds)
                .fill(Color.clear)
                .shadow(color: Color.black.opacity(0.6), radius: 50, x: 10, y: 10)
                .modifier(BlobEffect(
                    skewValue: isAnimating ? 2 : 0
                ))
                .modifier(BlobAnimationModifier(
                            skew: true,
                            breathe: true,
                            rotate: false,
                            isAnimating: $isAnimating)
                )
            // Blob: Gradient Layer
            ZStack {
                Rectangle()
                    .modifier(AnimatableColor(
                                colors: UIColor.blobColorArray,
                                pct: self.blobValue))
                    // Top left
                    .softInnerShadow(Rectangle(),
                                     //darkShadow: Color.white.opacity(0.8),
                                     lightShadow: .clear,
                                     spread: 1.0,
                                     radius: 30)
                    .blendMode(.overlay)

                    // Bottom right
                    .softInnerShadow(Rectangle(),
                                     darkShadow: .clear,
                                     lightShadow: Color.momoShadow.opacity(0.6),
                                     //lightShadow: Color.momoShadow.opacity(0.8),
                                     spread: 0.8,
                                     radius: 30)
                    .blendMode(.multiply)
            }
            .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
            .mask(self.animatingBlob)

        }
        .frame(width: scaledFrame, height: scaledFrame * (pathBounds.width / pathBounds.height))
        .onAppear {
            isAnimating = isStatic ? false : true
        }
    }
}

// MARK: - BlobAnimationModifier

struct BlobAnimationModifier: ViewModifier {
    @Binding var isAnimating: Bool

    let skew: Bool
    let breathe: Bool
    let rotate: Bool

    init(skew: Bool, breathe: Bool, rotate: Bool, isAnimating: Binding<Bool>) {
        self.skew = skew
        self.breathe = breathe
        self.rotate = rotate

        self._isAnimating = isAnimating
    }

    func body(content: Content) -> some View {
        content
            // Skew Effect
            .animation(self.skew ?
                Animation
                    .easeInOut(duration: 1.0)
                    .repeat(while: isAnimating)
                : nil
            )
            // Breathe Effect
            .scaleEffect(isAnimating ? 1.05 : 1)
            .animation(self.breathe ?
                Animation
                    .breathe
                    .repeat(while: isAnimating)
                : nil
            )
            // Rotate Effect
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .animation(self.rotate ?
                Animation
                    .linear(duration: 50)
                    .repeatForever(autoreverses: false)
                : nil
            )
    }
}

// MARK: - Blob Animation

struct BlobEffect: GeometryEffect {
    var skewValue: CGFloat
    var animatableData: CGFloat {
        get { skewValue }
        set { skewValue = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        //var skew: CGFloat { cos(skewValue + .pi / 2) * 1 }
        var skew: CGFloat { skewValue * 0.03 }
        
        // m34: sets the perspective parameter
        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1 / max(size.width, size.height)
        // Transform: Rotate
        // transform3d = CATransform3DRotate(transform3d, a, 0, 0, 1)
        // Transform: Scale
        // transform3d = CATransform3DScale(transform3d, scaleFactor, 1, 0)
        // Transform: Shifts anchor point of rotation (from top leading corner to centrer)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
        // Transform: Skew
        let skewTransform = ProjectionTransform(CGAffineTransform(a: 1, b: 0, c: skew, d: 1, tx: 0, ty: 0))
        // Transform: Shifts back to center
        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
        return ProjectionTransform(transform3d).concatenating(skewTransform).concatenating(affineTransform)
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

struct BlobShape_Previews: PreviewProvider {
    static var previews: some View {
        BlobView(blobValue: .constant(0.33), isStatic: false, isAnimating: false, scale: 1.0)
    }
}
