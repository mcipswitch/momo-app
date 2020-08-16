//
//  ContentView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

import SwiftUI

struct ContentView: View {
    let pathBounds = UIBezierPath.calculateBounds(paths: [.blob1, .blob2])
    var body: some View {
        ZStack {
            GradientView()
            Blob(bezier: .blob1, pathBounds: pathBounds)
                .frame(width: 200, height: 200 * pathBounds.height/pathBounds.width)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
