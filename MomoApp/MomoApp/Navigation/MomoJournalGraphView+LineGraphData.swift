//
//  LineGraphView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-24.
//

import SwiftUI
import ComposableArchitecture

/**
 Please see:
 https://www.objc.io/blog/2020/03/16/swiftui-line-graph-animation/
 https://crustlab.com/blog/ios-development-swiftui-experiment-building-custom-chart/
 */
struct LineGraphData: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    let dataPoints: [CGFloat]

    var body: some View {
        LinearGradient(.momo(.triColor), direction: .vertical)
            .mask(
                LineGraph(dataPoints: self.dataPoints)
                    .trim(to: self.viewStore.lineChartAnimationOn ? 1 : 0)
                    .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
            )
            .dropShadow()
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
        guard let origin = self.dataPoints.first else { return 0 }
        return origin
    }

    private var latestDataPoints: [CGFloat] {
        return self.dataPoints.suffix(7)
    }

    func path(in rect: CGRect) -> Path {
        /// Computes a CGPoint for a given data point.
        /// - Parameter ix: Index of current data point.
        /// - Returns: A `CGPoint`.
        func point(at ix: Int) -> CGPoint {
            let point = self.latestDataPoints[ix]
            let x = rect.width * CGFloat(ix) / CGFloat(self.latestDataPoints.count - 1)
            let y = (1-point) * rect.height
            return CGPoint(x: x, y: y)
        }

        return Path { p in
            guard self.latestDataPoints.count > 1 else { return }
            let start = self.latestDataPoints[0]

            // Set origin so line will start from the edge of the screen.
            // This gives the illusion of continuous data. This data point is from the entry 8 days ago.
            let x: CGFloat = (rect.width / CGFloat(self.latestDataPoints.count - 1)) * -1
            let origin = CGPoint(x: x, y: (1 - self.originPoint) * rect.height)
            p.move(to: origin)

            let next = point(at: 0)
            let curveXOffset = origin.curveXOffset(to: next, lineRadius: self.lineRadius)

            p.addCurve(to: next,
                       previous: origin,
                       curveXOffset: curveXOffset)

            /// Previous point used to calculate position of curve points.
            var previous = CGPoint(x: 0, y: (1 - start) * rect.height)

            for idx in self.latestDataPoints.indices {
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
