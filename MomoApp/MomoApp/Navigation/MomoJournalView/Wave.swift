//
//  Wave.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-24.
//
/*
 Resources:

 https://www.objc.io/blog/2020/03/16/swiftui-line-graph-animation/
 https://crustlab.com/blog/ios-development-swiftui-experiment-building-custom-chart/
 */

import SwiftUI

struct GraphView: View {
    @State var on = true

    let sampleData: [CGFloat] = [0.1, 0.67, 0.23, 0.05, 0.73, 0.25, 0.23]

    var body: some View {
        GeometryReader { geo in
            VStack {
                LineGraph(dataPoints: sampleData)
                    .trim(to: on ? 1 : 0) // reverse for animation
                    .stroke(Color.red, lineWidth: 8)
                    .aspectRatio(geo.size.height/geo.size.width, contentMode: .fit)
                Button("Animate") {
                    withAnimation(.easeInOut(duration: 1)) {
                        self.on.toggle()
                    }
                }
            }
        }
    }
}

struct LineGraph: Shape {
    /// Array of data points normalized to 0...1.
    var dataPoints: [CGFloat]
    /// Value within 0...1 range used to determine how curved the chart should be.
    var lineRadius: CGFloat = 0.5

    func path(in rect: CGRect) -> Path {
        /// Computes a CGPoint for a given data point.
        /// - Parameter ix: Index of current data point.
        /// - Returns: A `CGPoint`.
        func point(at ix: Int) -> CGPoint {
            let point = dataPoints[ix]
            let x = rect.width * CGFloat(ix) / CGFloat(dataPoints.count - 1)
            let y = (1-point) * rect.height
            return CGPoint(x: x, y: y)
        }

        return Path { p in
            guard dataPoints.count > 1 else { return }
            let start = dataPoints[0]
            p.move(to: CGPoint(x: 0, y: (1-start) * rect.height))

            // Previous point used to calculate position of curve points
            var previousPoint = CGPoint(x: 0, y: (1-start) * rect.height)

            for idx in dataPoints.indices {

                // Calculate X delta between current and previous point
                let next = point(at: idx)
                let deltaX = next.x - previousPoint.x

                // Determine how curved the chart should be
                let curveXOffset = deltaX * self.lineRadius

                // p.addLine(to: point(at: idx))
                p.addCurve(to: point(at: idx),
                           control1: CGPoint(x: previousPoint.x + curveXOffset, y: previousPoint.y), // offset to right
                           control2: CGPoint(x: next.x - curveXOffset, y: next.y))                   // offset to left

                previousPoint = point(at: idx)
            }
        }
    }
}

// MARK: - Previews

struct Wave_Previews: PreviewProvider {
    static var previews: some View {
        LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            .mask(
                GraphView(on: true)
            )
    }
}
