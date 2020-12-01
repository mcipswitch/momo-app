//
//  LineGraphView.swift
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

// MARK: - LineGraphView

struct LineGraphView: View {
    @EnvironmentObject var viewRouter: ViewRouter

    /// Set as `false` to control animation from `ViewRouter`.
    @State var on = false
    let dataPoints: [CGFloat]

    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.momo, Color.momoOrange, Color.momoPurple]),
                       startPoint: .top, endPoint: .bottom)
            .mask(
                LineGraph(dataPoints: self.dataPoints)
                    .trim(to: on ? 1 : 0)
                    .stroke(Color.purple, style: StrokeStyle(lineWidth: 6, lineCap: .round))
            )
            .onReceive(self.viewRouter.objectWillChange, perform: {
                // Animate line if in JournalView, otherwise no animation
                withAnimation(self.viewRouter.isHome
                                ? Animation.linear.delay(0.2)
                                : Animation.easeInOut(duration: 1.5).delay(0.6)) {
                    self.on.toggle()
                }
            })
            .shadow()
    }
}

// MARK: - LineGraph

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

            /**
             Set origin point so that the line will start from the edge of the screen.
             At this moment, this point is arbitrary to give the illusion of continuous data.
             */
            let origin = CGPoint(x: -32, y: (1-start) * rect.height)
            p.move(to: origin)

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
        LineGraphView(on: true, dataPoints: [0.3, 0.4, 0.5, 0.3, 0.2, 0.3, 0.9])
            .environmentObject(ViewRouter())
    }
}
