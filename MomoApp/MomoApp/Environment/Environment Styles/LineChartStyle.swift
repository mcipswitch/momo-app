//
//  LineChartStyle.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-20.
//
/*
 For styling, please see:
 https://swiftwithmajid.com/2020/12/09/styling-custom-swiftui-views-using-environment/
 */

import SwiftUI

// MARK: - LineChartStyle

// TODO: - clean all this up
public struct LineChartStyle {
    let lineFrameWidth: CGFloat
    let selectionLineWidth: CGFloat
    let labelPadding: CGFloat

    let duration: Double = 2.0
    let delay: Double = 0.4

    var lineGraphAnimation: Animation {
        Animation.easeInOut(duration: duration).delay(delay)
    }

    var selectionLineAnimation: Animation {
        Animation.easeInOut(duration: 1.0).delay(duration + delay)
    }

    var columnLayout: (CGFloat, Int) -> [GridItem] = { (spacing, count) -> [GridItem] in
        Array(
            repeating: .init(.flexible(), spacing: spacing),
            count: count)
    }

    public init(
        lineFrameWidth: CGFloat = 25.0,
        selectionLineWidth: CGFloat = 4.0,
        labelPadding: CGFloat = 8.0
    ) {
        self.lineFrameWidth = lineFrameWidth
        self.selectionLineWidth = selectionLineWidth
        self.labelPadding = labelPadding
    }
}

// MARK: - LineChartStyleEnvironmentKey

struct LineChartStyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: LineChartStyle = .init()
}

// MARK: - EnvironmentValues+Extensions

extension EnvironmentValues {
    /// An additional environment value that will hold the line chart style.
    var lineChartStyle: LineChartStyle {
        get { self[LineChartStyleEnvironmentKey.self] }
        set { self[LineChartStyleEnvironmentKey.self] = newValue }
    }
}

// MARK: - View+Extensions

extension View {
    /// An extension on View protocol that allows us to insert chart styles into a view hierarchy environment.
    func msk_applyLineChartStyle(_ style: LineChartStyle) -> some View {
        environment(\.lineChartStyle, style)
    }
}
