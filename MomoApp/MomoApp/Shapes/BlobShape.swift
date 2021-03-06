//
//  BlobView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

/*
 Please see:
 http://www.code-disciple.com/creating-smooth-animation-like-headspace-app/
 https://www.youtube.com/watch?v=IUpN7sIwaqc
 https://swiftui-lab.com/swiftui-animations-part1/
 */

import SwiftUI
import Neumorphic

struct BlobView: View {
    @Environment(\.blobStyle) var blobStyle
    @Binding var blobValue: CGFloat
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            blobShadow
            blobGradient
        }
        .frame(width: self.blobStyle.scaledFrame,
               height: self.blobStyle.scaledFrame * self.blobStyle.pathBoundsRadio)
        .onAppear {
            self.isAnimating = !self.blobStyle.isStatic
        }
    }

    // MARK: - Internal Views

    private var animatingBlobMask: some View {
        BlobShape(bezier: self.blobStyle.bezier, pathBounds: self.blobStyle.pathBounds)
            .blobAnimation(skew: true,
                           breathe: true,
                           rotate: true,
                           isAnimating: $isAnimating)
    }

    private var blobShadow: some View {
        BlobShape(bezier: self.blobStyle.bezier, pathBounds: self.blobStyle.pathBounds)
            .fill(Color.clear)
            .shadow(color: self.blobStyle.shadowColor,
                    radius: self.blobStyle.shadowRadius,
                    x: self.blobStyle.shadowOffset.x,
                    y: self.blobStyle.shadowOffset.y)
            .blobAnimation(skew: true,
                           breathe: true,
                           rotate: false,
                           isAnimating: self.$isAnimating)
    }

    private var blobGradient: some View {
        ZStack {
            Rectangle()
                .modifier(AnimatableColor(
                            colors: UIColor.blobColorArray,
                            pct: self.blobValue))
                .softInnerShadow(Rectangle(),
                                 darkShadow: self.blobStyle.innerTopLeftShadowDarkShadow,
                                 lightShadow: self.blobStyle.innerTopLeftShadowLightShadow,
                                 spread: self.blobStyle.innerTopLeftShadowSpread,
                                 radius: self.blobStyle.innerTopLeftShadowRadius)
                .blendMode(.overlay)
                .softInnerShadow(Rectangle(),
                                 darkShadow: self.blobStyle.innerBottomRightShadowDarkShadow,
                                 lightShadow: self.blobStyle.innerBottomRightShadowLightShadow,
                                 spread: self.blobStyle.innerBottomRightShadowSpread,
                                 radius: self.blobStyle.innerBottomRightShadowRadius)
                .blendMode(.multiply)
        }
        .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
        .mask(self.animatingBlobMask)
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

    private var skewEffect: Animation {
        Animation
            .easeInOut(duration: 1.0)
            .repeat(while: isAnimating)
    }

    private var breatheEffect: Animation {
        Animation
            .breathe
            .repeat(while: isAnimating)
    }

    private var rotateEffect: Animation {
        Animation
            .linear(duration: 50)
            .repeatForever(autoreverses: false)
    }

    func body(content: Content) -> some View {
        content
            .modifier(BlobEffect(
                skewValue: self.isAnimating ? 2 : 0
            ))
            .animation(self.skew ? skewEffect : nil, value: isAnimating)
            .scaleEffect(isAnimating ? 1.05 : 1)
            .animation(self.breathe ? breatheEffect : nil, value: isAnimating)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .animation(self.rotate ? rotateEffect : nil, value: isAnimating)
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
        // Transform: Shifts anchor point of rotation (from top leading corner to centre)
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

// MARK: - View+Extensions

extension View {
    func blobAnimation(skew: Bool, breathe: Bool, rotate: Bool, isAnimating: Binding<Bool>) -> some View {
        return self.modifier(BlobAnimationModifier(skew: skew, breathe: breathe, rotate: rotate, isAnimating: isAnimating))
    }
}
