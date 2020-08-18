//
//  Blob.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

import SwiftUI

struct BlobView: View {
    let frameSize: CGFloat = 250
    let pathBounds = UIBezierPath.calculateBounds(paths: [.blob3])
    
    var body: some View {
        VStack {
            Blob(bezier: .blob3, pathBounds: pathBounds)
                .fill(RadialGradient(
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 1, alpha: 1)),  Color(#colorLiteral(red: 0.7960784314, green: 0.5411764706, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.431372549, green: 0.4901960784, blue: 0.9843137255, alpha: 1))]),
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: pathBounds.width * 1.5)
                )
                .frame(width: frameSize, height: frameSize * pathBounds.width / pathBounds.height)
                .shadow(color: Color.black.opacity(0.6), radius: 50, x: 10, y: 10)
        }
    }
}

struct Blob: Shape {
    let bezier: UIBezierPath
    let pathBounds: CGRect
    func path(in rect: CGRect) -> Path {
        let centerPoint = CGPoint(x: rect.midX, y: rect.midY)
        let pointScale = (rect.width >= rect.height) ?
            max(pathBounds.height, pathBounds.width) :
            min(pathBounds.height, pathBounds.width)
        let pointTransform = CGAffineTransform(scaleX: 1/pointScale, y: 1/pointScale)
        let path = Path(bezier.cgPath).applying(pointTransform)
        let multiplier = min(rect.width, rect.height)
        let transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
        let offsetTransform = CGAffineTransform(translationX: centerPoint.x, y: centerPoint.y)
        return path.applying(transform).applying(offsetTransform)
    }
}

struct Blob_Previews: PreviewProvider {
    static var previews: some View {
        BlobView()
    }
}
