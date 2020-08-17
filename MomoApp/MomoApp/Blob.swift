//
//  Blob.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

import SwiftUI

struct Blob: Shape {
    let bezier: UIBezierPath
    //let pathBounds: CGRect
    func path(in rect: CGRect) -> Path {
        let path = Path(bezier.cgPath)
        return path
        
//        let pointScale = (rect.width >= rect.height) ?
//            max(pathBounds.height, pathBounds.width) :
//            min(pathBounds.height, pathBounds.width)
//        let pointTransform = CGAffineTransform(scaleX: 1/pointScale, y: 1/pointScale)
//        let path = Path(bezier.cgPath).applying(pointTransform)
//        let multiplier = min(rect.width, rect.height)
//        let transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
//        return path.applying(transform)
    }
}

struct Blob_Previews: PreviewProvider {
    static var previews: some View {
        Blob(bezier: .blob4)
            .stroke(Color(#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)), lineWidth: 2)
            .frame(width: 300, height: 300)
    }
}
