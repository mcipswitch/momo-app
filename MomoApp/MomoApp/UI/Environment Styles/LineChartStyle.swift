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

public struct LineChartStyle {
    let selectionLineWidth: CGFloat
    let lineAnimationDuration: Double
    let labelPadding: CGFloat

    let numOfItems: CGFloat
    let itemWidth: CGFloat

    var totalItemWidth: CGFloat { itemWidth * numOfItems }
    var columnLayout: (CGFloat, Int) -> [GridItem] = { (spacing, count) -> [GridItem] in
        Array(
            repeating: .init(.flexible(), spacing: spacing),
            count: count)
    }

    public init(
        selectionLineWidth: CGFloat = 4.0,
        lineAnimationDuration: Double = 3.0,
        labelPadding: CGFloat = 8.0,

        numOfItems: CGFloat = 7,
        itemWidth: CGFloat = 25
    ) {
        self.selectionLineWidth = selectionLineWidth
        self.lineAnimationDuration = lineAnimationDuration
        self.labelPadding = labelPadding

        self.numOfItems = numOfItems
        self.itemWidth = itemWidth
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
