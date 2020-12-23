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
    // TODO: - Remove the environment here
    @Environment(\.lineChartStyle) var lineChartStyle
    @EnvironmentObject var viewRouter: ViewRouter
    @State var lineOn = false
    @State var opacity = true
    let dataPoints: [CGFloat]

    var body: some View {
        LinearGradient(.momoTriColorGradient)
            .mask(
                LineGraph(dataPoints: self.dataPoints)
                    .trim(to: self.lineOn ? 1 : 0)
                    .stroke(style: .lineGraphStrokeStyle)
            )
            .opacity(opacity ? 1 : 0)
            .onAppear(perform: animateIn)
            .onReceive(viewRouter.objectWillChange, perform: animateOut)
            .msk_applyDropShadow()
    }
}

// MARK: - Internal Methods

extension LineGraphView {
    private func animateIn() {
        withAnimation(lineChartStyle.lineGraphAnimation) {
            self.lineOn.toggle()
        }
    }

    private func animateOut() {
        withAnimation { self.opacity.toggle() }
    }
}

// MARK: - LineGraph

struct LineGraph: Shape {

    /// Array of data points normalized to 0...1.
    /// Index [0] is the origin point, followed by the last 7 entries.
    var dataPoints: [CGFloat]

    /// Value within 0...1 range used to determine how curved the chart should be.
    var lineRadius: CGFloat = 0.5

    private var originPoint: CGFloat {
        guard let origin = dataPoints.first else { return 0 }
        return origin
    }

    private var latestDataPoints: [CGFloat] {
        return dataPoints.suffix(7)
    }

    func path(in rect: CGRect) -> Path {
        /// Computes a CGPoint for a given data point.
        /// - Parameter ix: Index of current data point.
        /// - Returns: A `CGPoint`.
        func point(at ix: Int) -> CGPoint {
            let point = latestDataPoints[ix]
            let x = rect.width * CGFloat(ix) / CGFloat(latestDataPoints.count - 1)
            let y = (1-point) * rect.height
            return CGPoint(x: x, y: y)
        }

        return Path { p in
            guard latestDataPoints.count > 1 else { return }
            let start = latestDataPoints[0]
            /**
             Set origin point so that the line will start from the edge of the screen.
             This gives the illusion of continuous data. This data point is from the entry 8 days ago.
             */
            let x: CGFloat = (rect.width / CGFloat(latestDataPoints.count - 1)) * -1
            let origin = CGPoint(x: x, y: (1 - originPoint) * rect.height)
            p.move(to: origin)

            let next = point(at: 0)
            let curveXOffset = origin.curveXOffset(to: next, lineRadius: self.lineRadius)

            p.addCurve(to: next,
                       previous: origin,
                       curveXOffset: curveXOffset)

            /// Previous point used to calculate position of curve points.
            var previous = CGPoint(x: 0, y: (1 - start) * rect.height)

            for idx in latestDataPoints.indices {
                let next = point(at: idx)
                let curveXOffset = previous.curveXOffset(to: next, lineRadius: self.lineRadius)

                p.addCurve(to: next,
                           previous: previous,
                           curveXOffset: curveXOffset)

                previous = point(at: idx)
            }
        }
    }
}

// MARK: - StrokeStyle+Extension

extension StrokeStyle {
    static let lineGraphStrokeStyle = StrokeStyle(lineWidth: 6, lineCap: .round)
}
