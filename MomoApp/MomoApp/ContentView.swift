//
//  ContentView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

import SwiftUI

struct ContentView: View {
    let frameSize: CGFloat = 250
    //let pathBounds = UIBezierPath.calculateBounds(paths: [.blob1, .blob2, .blob3, .blob4])
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GradientView()
                ZStack {
                    Blob(bezier: .blob4)
                        .fill(Color.orange)
                        .position(CGPoint(x: frameSize, y: frameSize))
                        .frame(width: frameSize, height: frameSize, alignment: .center)
                        .background(Color.white.opacity(0.3))
                }
//                .frame(width: frameSize, height: frameSize * pathBounds.height/pathBounds.width)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
