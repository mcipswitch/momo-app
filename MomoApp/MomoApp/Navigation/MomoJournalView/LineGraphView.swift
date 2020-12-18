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

 For styling, please see:
 https://swiftwithmajid.com/2020/12/09/styling-custom-swiftui-views-using-environment/
 */

import SwiftUI

// MARK: - LineGraphView

struct LineGraphView: View {
    typealias Graph = MSK.Journal.Graph

    @EnvironmentObject var viewRouter: ViewRouter
    @State var lineOn = false
    let dataPoints: [CGFloat]

    var body: some View {
        lineGraphBackgroundGradient
            .mask(
                LineGraph(dataPoints: self.dataPoints)
                    .trim(to: self.lineOn ? 1 : 0)
                    .stroke(style: .lineGraphStrokeStyle)
            )
            .onAppear(perform: animateLine)
            .msk_applyDropShadow()
    }

    private var lineGraphBackgroundGradient: some View {
        LinearGradient(gradient: .momoTriColorGradient,
                       startPoint: .bottom,
                       endPoint: .top)
    }


    // MARK: - Internal Methods

    private func animateLine() {
        var duration: Double { Graph.lineAnimationDuration }
        withAnimation(.easeInOut(duration: duration)) {
            self.lineOn.toggle()
        }
    }
}

// MARK: - LineGraph

struct LineGraph: Shape {

    /// Array of data points normalized to 0...1.
    /// Index [0] is the origin point, followed by the last 7 entries.
    var dataPoints: [CGFloat]

    private var originPoint: CGFloat {
        guard let origin = dataPoints.first else { return 0 }
        return origin
    }

    private var latestDataPoints: [CGFloat] {
        return dataPoints.suffix(7)
    }

    /// Value within 0...1 range used to determine how curved the chart should be.
    var lineRadius: CGFloat = 0.5

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

            // TODO: - fix x = -32 to non fixed number
            let origin = CGPoint(x: -32, y: (1 - originPoint) * rect.height)
            p.move(to: origin)

            let next = point(at: 0)
            let curveXOffset = origin.curveXOffset(to: next, lineRadius: self.lineRadius)

            p.addCurve(to: next,
                       control1: CGPoint(x: origin.x + curveXOffset, y: origin.y),
                       control2: CGPoint(x: next.x - curveXOffset, y: next.y))

            /// Previous point used to calculate position of curve points.
            var previous = CGPoint(x: 0, y: (1 - start) * rect.height)

            for idx in latestDataPoints.indices {

                let next = point(at: idx)
                let curveXOffset = previous.curveXOffset(to: next, lineRadius: self.lineRadius)

                p.addCurve(to: next,
                           control1: CGPoint(x: previous.x + curveXOffset, y: previous.y), // offset to right
                           control2: CGPoint(x: next.x - curveXOffset, y: next.y))                   // offset to left

                previous = point(at: idx)
            }
        }
    }
}

// MARK: - StrokeStyle+Extension

extension StrokeStyle {
    static let lineGraphStrokeStyle = StrokeStyle(lineWidth: 6, lineCap: .round)
}

// MARK: - Previews

struct Wave_Previews: PreviewProvider {
    static var previews: some View {
        LineGraphView(lineOn: true, dataPoints: [0.3, 0.4, 0.5, 0.3, 0.2, 0.3, 0.9])
            .environmentObject(ViewRouter())
    }
}
